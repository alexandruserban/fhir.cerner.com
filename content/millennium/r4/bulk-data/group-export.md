---
title: Group Export | R4 API
---

# Group Export

<%= beta_tag %>

* TOC
{:toc}

## Overview

The Group Export operation is used to obtain FHIR resources for all members of a specified group of patients.

An Export process uses the [FHIR Asynchronous Request Pattern](https://hl7.org/fhir/R4/async.html) to kick off the export job for a group of patients. Once the export job is kicked off, the status endpoint may be called to check the progress of the job. Once the job is complete, the status endpoint returns a list of files which may be downloaded using the file retrieval endpoint. After the appropriate ndjson files are downloaded, the delete endpoint should be called to clean up the no longer needed files.

By default, the Group Export operation exports resources required for [United States Core Data for Interoperability (USCDI)](https://www.healthit.gov/isa/united-states-core-data-interoperability-uscdi). For a full list of resources see the [US Core Profiles](https://hl7.org/fhir/us/core/#us-core-profiles). When the _type parameter is used it returns only the FHIR resources specified. The _type parameter should be used to filter the resources required for a specific use case. Limiting the number of requested resources in the _type parameter is recommended as it can decrease response times.

Client application developers will need to work with healthcare organizations to be granted access to the Group $export operation and to be provided with Groups to be exported. Organizations can manage Groups within [Ignite Management Tooling](https://cernercentral.com/ignite-management).

_Notes_

* Authentication is required, open endpoints do not support bulk export workflows
* Cerner supports v1.0.1 of the [FHIR Bulk Data Access (FLATFHIR) Implementation Guide](https://hl7.org/fhir/uv/bulkdata/STU1.0.1/)
* Bulk data runs against an organization's database and utilizes the same services running other applications, so it is important to consider performance. Bulk data exports large amounts of data for large groups of patients, which takes more time to complete the larger the data set or patient population.

### When to use bulk data

Ensure bulk data's technical capabilities align with your use case.

#### Good use cases

* A one-time load of data in preparation for continuous data exchange using other methods
* Monthly loads of a targeted set of data (for example, `_type=Patient,Condition`)
* Weekly export of a dynamic group of patients (for example, all patients discharged in the last week with a certain diagnosis)
* Weekly loads of small patient populations (less than one hundred), such as for registry submissions

#### Bad use cases

* Data synchronization with data warehouses or other databases
* Periodic loads of large amounts of clinical data
* Incremental data loads

### Best Practices

* Limit group sizes to around a thousand patients or fewer.
* Use the _type parameter whenever possible to improve response time and minimize storage requirements.
* For groups of under one hundred patients, check the request status every ten minutes, or use exponential backoff. For groups of over one hundred patients, check the status every thirty minutes, or use exponential backoff. More information on exponential backoff can be found in the bulk data export specification.
* Files should be retrieved promptly as the exported content will expire after 30 days.
* After retrieving all of the resource file content, use the FHIR Bulk Data Delete Request API to allow the server to clean up the data from your request.

## Kick-off Request

Kicks off a bulk export request for a group of patients:

    GET /Group/<group_id>/$export

Operation is defined at:

    GET /OperationDefinition/group-export?_format=json

_Implementation Notes_

* Bulk data export requests do not currently honor the Accept-Language header; 'en-US' will be used.
* Only one bulk export request for a client application and tenant combination may be in-progress at a single time.

### Authorization Types

<%= authorization_types(provider: false, patient: false, system: true) %>

_Notes_

* Token does NOT require the `Group.read` scope
* Token must contain system read scopes for all resources requested in the `_type` parameter

### Parameters

Name                    | Required? | Type       | Description
------------------------|-----------|------------|---------------------------------------------------------------------------------------------------
`_type`                 | No        | [`string`] | A string of comma-delimited FHIR resource types. Example: `_type=Patient,Encounter,Location`
`_outputFormat`         | No        | [`string`] | The format for the requested bulk data files to be generated. Example: `_outputFormat=application/ndjson`
`includeAssociatedData` | No        | [`string`] | A string of comma-delimited values. Example: `includeAssociatedData=LatestProvenanceResources`

_Notes_

* `_type` valid parameters are `AllergyIntolerance`, `CarePlan`, `CareTeam`, `Condition`, `Device`, `DiagnosticReport`, `DocumentReference`, `Encounter`, `Goal`, `Immunization`, `Location`, `MedicationRequest`, `Patient`, `Procedure`, `Observation`, `Organization`, `Practitioner`, `Provenance`
* When the `_type` parameter contains a reference resource (`Location`, `Organization`, `Practitioner`) or associated resource(`Provenance`), at least one of the following resources must also be provided: `AllergyIntolerance`, `CarePlan`, `CareTeam`, `Condition`, `Device`, `DiagnosticReport`, `DocumentReference`, `Encounter`, `Goal`, `Immunization`, `MedicationRequest`, `Observation`, `Patient`, `Procedure`
* When the `_type` parameter is not provided, the resources to be exported will be determined by the scopes provided in the authorization token
* `_outputFormat` valid parameters are `application/fhir+ndjson`, `application/ndjson`, `ndjson`
* `_outputFormat` defaults to `application/fhir+ndjson` when not provided
* The following parameters are not supported: `_since`, `_elements`, `patient`, `_typeFilter`
* `includeAssociatedData` valid parameters are `LatestProvenanceResources` and `RelevantProvenanceResources`

_Provenance Behavior_

* When the `_type` parameter is not provided and the token includes the Provenance read scope, all relevant Provenance resources associated with each of the non-provenance resources will be exported by default. You MAY use the  `includeAssociatedData` parameter to return only the latest provenance.
* When the `_type` parameter is provided with specific resources and includes 'Provenance', all relevant Provenance resources associated with each of the non-provenance resources will be exported by default.
* When both the `includeAssociatedData` parameter and the _`type` parameter are provided, the _`type` parameter MUST include `Provenance`
* Provenances for `Location`, `Organization`, and `Practitioner` will not be exported

### Headers

<%= headers head: {'Accept': 'application/fhir+json', 'Prefer': 'respond-async', Authorization: '&lt;OAuth2 Bearer Token>'} %>

Optional Header

<%= headers head: {'Prefer': 'handling=lenient'} %>

When the Prefer: handling=lenient is provided any unknown or unsupported parameters will be ignored as specified [here](https://hl7.org/fhir/uv/bulkdata/export.html#query-parameters).

### Example

Request

    GET https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/Group/252a42c0-5844-11ec-bf63-0242ac130002/$export

Response

    Status: 202 Accepted
    Content-Location: https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/jobs/<job_id>

<%= disclaimer %>

### Errors

The common [errors] and [OperationOutcomes] may be returned.

## Status Request

Use the URL returned in the `Content-Location` header from the kick-off request to retrieve the status of a bulk data export:

    GET /bulk-data/jobs/<job_id>

_Notes_

* Clients should follow an Exponential Backoff approach when polling for status as outlined in the [bulk data export specification.](https://hl7.org/fhir/uv/bulkdata/STU1.0.1/export/index.html#bulk-data-status-request)

### Authorization Types

<%= authorization_types(provider: false, patient: false, system: true) %>

### Headers

<%= headers head: {'Accept': 'application/fhir+json', Authorization: '&lt;OAuth2 Bearer Token>'} %>

### Example

#### In-Progress Response

Request

    GET https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/jobs/<job_id>

Response

    Status: 202 Accepted
    X-Progress: in-progress

#### Complete Response

Request

    GET https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/jobs/<job_id>

Response

    Status: 200 OK
    Expires: Mon, 22 Jul 2025 23:59:59 GMT
    Content-Type: application/json

<%= json(:R4_BULK_EXPORT_COMPLETE) %>

<%= disclaimer %>

### Errors

The common [errors] and [OperationOutcomes] may be returned.

## File Retrieval Request

Once an export is complete, the status endpoint will return file URLs which may be used to download the exported resources

    GET /bulk-data/files/<file_id>

_Implementation Notes_

* The file retrieval endpoint returns a '307 Temporary Redirect' with a 'Location' header, the Location header must be followed in order to download the file
* An exported ndjson file contains only a single resource type and there can be multiple files for the same resource type. There is no limit number of resources per file
* An exported file has a size maximum of TODO: TBD
* Files should be retrieved promptly, as they will expire after a reasonable period
* The initial file retrieval request requires the Authorization header to be sent, when following the re-direct, it is no longer appropriate. Ensure the Authorization header is not perpetuated.
* The Authorization token must contain the system read scope for the resource that the export file contains

_Retrieval of Attachments_

* Binary resources are not returned by bulk data operations
* DocumentReference and DiagnosticReport will only return `text/xml`, `text/html`, and `application/xhtml+xml` attachment types
* Attachment references must be retrieved separately using the Binary resource URL from the DocumentReference.content.attachment and DiagnosticReport.presentedForm fields from the export files

### Authorization Types

<%= authorization_types(provider: false, patient: false, system: true) %>

### Headers

<%= headers head: {Authorization: '&lt;OAuth2 Bearer Token>', Accept: 'application/fhir+ndjson'} %>

### Example

Request

    GET https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/files/<file_id>

Response

    Status: 307 Temporary Redirect
    Location: https://cerner-opensvc-bulkfhir-processed.s3.us-west-2.amazonaws.com

<%= disclaimer %>

### Example: Following the 307 Redirect

Request

    GET https://cerner-opensvc-bulkfhir-processed.s3.us-west-2.amazonaws.com

_Notes_

* When following the re-direct link from the 'Location' header, an Authorization header should NOT be set as the url is pre-signed.
* Redirect links are short-lived and files are deleted 30 days after creation

Response

    Status: 200 OK
    Content-Type: application/fhir+ndjson

TODO: add ndjson file example json(:R4_BULK_EXPORT_FILE)

<%= disclaimer %>

### Errors

The common [errors] and [OperationOutcomes] may be returned.

## Delete Request

Use the URL returned in the `Content-Location` header from the kick-off request to delete a bulk data export job (whether it's in-progress or complete) and any associated files:

    DELETE /bulk-data/jobs/<job_id>

### Authorization Types

<%= authorization_types(provider: false, patient: false, system: true) %>

### Headers

<%= headers head: {'Accept': 'application/fhir+json', Authorization: '&lt;OAuth2 Bearer Token>'} %>

### Example

Request

    DELETE https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/jobs/<job_id>

Response

    Status: 202 Accepted

<%= disclaimer %>

### Errors

The common [errors] and [OperationOutcomes] may be returned.

## Testing in sandbox

In order to call bulk data endpoints in sandbox, you will need to kick off a group export using one of the group ids listed below and then perform the subsequent requests.

* Group with 3 patients: `11ec-d16a-c763b73e-98e8-a31715e6a2bf`
* Group with 10 patients: `11ec-d16a-b40370f8-9d31-577f11a339c5`

### Example

    GET https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/Group/11ec-d16a-c763b73e-98e8-a31715e6a2bf/$export&_type=Patient

[errors]: ../../#client-errors
[OperationOutcomes]: ../../#operation-outcomes
[`string`]: https://hl7.org/fhir/R4/search.html#string
