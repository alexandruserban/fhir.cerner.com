
# frozen_string_literal: true

module Cerner
  module Resources
    R4_BULK_EXPORT_COMPLETE ||= {
      'transactionTime': '2022-01-04T17:42:25.000Z',
      'request': 'https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/Group/252a42c0-5844-11ec-bf63-0242ac130002/$export?_type=Patient,Observation',
      'requiresAccessToken': true,
      'output': [
        {
          'type': 'Patient',
          'url': 'https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/files/96295b8c-584e-11ec-bf63-0242ac130002'
        },
        {
          'type': 'Patient',
          'url': 'https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/files/96295b8c-584e-11ec-bf63-0242ac130003'
        },
        {
          'type': 'Observation',
          'url': 'https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/files/96295b8c-584e-11ec-bf63-0242ac130004'
        }
      ],
      'error': [
        {
          'type': 'OperationOutcome',
          'url': 'https://fhir-ehr.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d/bulk-export/files/96295b8c-584e-11ec-bf63-0242ac130005'
        }
      ]
    }.freeze

    # R4_BULK_EXPORT_FILE ||= [
    #   {
    #     "resourceType": "Patient",
    #     "id": "744113",
    #     "meta": {
    #       "versionId": "5",
    #       "lastUpdated": "2018-04-11T16:01:36.000Z"
    #     },
    #     "text": {
    #       "status": "generated",
    #       "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Patient</b></p><p><b>Name</b>: Rollie, Vincent</p><p><b>Status</b>: Active</p></div>"
    #     },
    #     "identifier": [
    #       {
    #         "id": "CI-16342471-0",
    #         "use": "usual",
    #         "type": {
    #           "coding": [
    #             {
    #               "system": "https://fhir.cerner.com/eb2384f8-839e-4c6e-8b29-18e71db1a0b1/codeSet/4",
    #               "code": "2",
    #               "display": "CMRN",
    #               "userSelected": true
    #             },
    #             {
    #               "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
    #               "code": "MR",
    #               "display": "Medical record number",
    #               "userSelected": false
    #             }
    #           ],
    #           "text": "CMRN"
    #         },
    #         "_system": {
    #           "extension": [
    #             {
    #               "valueCode": "unknown",
    #               "url": "http://hl7.org/fhir/StructureDefinition/data-absent-reason"
    #             }
    #           ]
    #         },
    #         "value": "101512",
    #         "_value": {
    #           "extension": [
    #             {
    #               "valueString": "00-0101512",
    #               "url": "http://hl7.org/fhir/StructureDefinition/rendered-value"
    #             }
    #           ]
    #         },
    #         "period": {
    #           "start": "2018-04-12T21:30:29.000Z"
    #         }
    #       }
    #     ],
    #     "active": true,
    #     "name": [
    #       {
    #         "id": "CI-744113-0",
    #         "use": "official",
    #         "text": "Rollie, Vincent",
    #         "family": "Rollie",
    #         "given": [
    #           "Vincent"
    #         ],
    #         "period": {
    #           "start": "2011-01-14T05:06:42.000Z"
    #         }
    #       }
    #     ]
    #   }
    #   {
    #     "resourceType": "Patient",
    #     "id": "744115",
    #     "meta": {
    #       "versionId": "4",
    #       "lastUpdated": "2018-04-11T16:01:36.000Z"
    #     },
    #     "text": {
    #       "status": "generated",
    #       "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Patient</b></p><p><b>Name</b>: Coleman, Richard</p><p><b>Status</b>: Active</p></div>"
    #     },
    #     "identifier": [
    #       {
    #         "id": "CI-16342473-0",
    #         "use": "usual",
    #         "type": {
    #           "coding": [
    #             {
    #               "system": "https://fhir.cerner.com/eb2384f8-839e-4c6e-8b29-18e71db1a0b1/codeSet/4",
    #               "code": "2",
    #               "display": "CMRN",
    #               "userSelected": true
    #             },
    #             {
    #               "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
    #               "code": "MR",
    #               "display": "Medical record number",
    #               "userSelected": false
    #             }
    #           ],
    #           "text": "CMRN"
    #         },
    #         "_system": {
    #           "extension": [
    #             {
    #               "valueCode": "unknown",
    #               "url": "http://hl7.org/fhir/StructureDefinition/data-absent-reason"
    #             }
    #           ]
    #         },
    #         "value": "101513",
    #         "_value": {
    #           "extension": [
    #             {
    #               "valueString": "00-0101513",
    #               "url": "http://hl7.org/fhir/StructureDefinition/rendered-value"
    #             }
    #           ]
    #         },
    #         "period": {
    #           "start": "2018-04-12T21:30:29.000Z"
    #         }
    #       }
    #     ],
    #     "active": true,
    #     "name": [
    #       {
    #         "id": "CI-744115-0",
    #         "use": "official",
    #         "text": "Coleman, Richard",
    #         "family": "Coleman",
    #         "given": [
    #           "Richard"
    #         ],
    #         "period": {
    #           "start": "2011-01-14T05:06:43.000Z"
    #         }
    #       }
    #     ]
    #   }
    # ].freeze
  end
end
