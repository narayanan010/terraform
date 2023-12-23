import boto3
import json
import logging

log = logging.getLogger()
log.setLevel(logging.DEBUG)
APPLICABLE_RESOURCES = ["AWS::S3::Bucket"]


def evaluate_compliance(configuration_item):
    if configuration_item["resourceType"] not in APPLICABLE_RESOURCES:
        return {
            "compliance_type": "NOT_APPLICABLE",
            "annotation": "The rule doesn't apply to resources of type " +
            configuration_item["resourceType"] + "."
        }

    if configuration_item['configurationItemStatus'] == "ResourceDeleted":
        return {
            "compliance_type": "NOT_APPLICABLE",
            "annotation": "The configurationItem was deleted " +
                          "and therefore cannot be validated"
        }

    bucket_policy = configuration_item["supplementaryConfiguration"].get("BucketPolicy")
    if bucket_policy['policyText'] is None:
        return {
            "compliance_type": "NON_COMPLIANT",
            "annotation": 'Bucket Policy does not exists'
        }

    else:
        return {
            "compliance_type": "COMPLIANT",
            "annotation": 'Bucket Policy exists'
        }


def lambda_handler(event, context):
    log.debug('Event %s', event)
    invoking_event      = json.loads(event['invokingEvent'])
    configuration_item  = invoking_event["configurationItem"]
    evaluation          = evaluate_compliance(configuration_item)
    config              = boto3.client('config')

    config.put_evaluations(
       Evaluations=[
           {
               'ComplianceResourceType':    invoking_event['configurationItem']['resourceType'],
               'ComplianceResourceId':      invoking_event['configurationItem']['resourceId'],
               'ComplianceType':            evaluation["compliance_type"],
               "Annotation":                evaluation["annotation"],
               'OrderingTimestamp':         invoking_event['configurationItem']['configurationItemCaptureTime']
           },
       ],
       ResultToken=event['resultToken'])
