import boto3
import json
import re
import urllib.parse

print('Loading function')
LOGS_PATTERNS_TO_BE_FORWARDED = []
DATADOG_FORWARDER_LAMBDA = "datadog-forwarder-Forwarder-z82yB02didLe"

s3 = boto3.client('s3')
function = boto3.client('lambda')


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event['Records'][0]['eventName'], indent=2))

    # Get the object from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    print("Key: %s" % key)

    # Parse with re
    pattern = "(\d+)/(\w+)/(\w+)\.(\d{4})-(\d{2})-(\d{2})-(\d{2})\.(\w+\.gz)"
    m = re.match(pattern, key)
    if not m:
        print("Key %s doesn't match defined pattern %s" % (key, pattern))
        return 0
    (account_id, distribution_id, distribution_id_2, year, month, day, hour, unique_part) = m.groups()
    target_key = "/".join([account_id, distribution_id, year, month, day, hour, 'cloudfront_' + unique_part])
    print("Target key: %s" % target_key)
    copy_source = "/" + bucket + "/" + key

    # Move
    try:
        response_copy = s3.copy_object(
            Bucket=bucket,
            CopySource=copy_source,
            Key=target_key
        )
        print("Copy status code: %s" % response_copy['ResponseMetadata']['HTTPStatusCode'])
        response_delete = s3.delete_object(
            Bucket=bucket,
            Key=key
        )
        print("Delete status code: %s" % response_delete['ResponseMetadata']['HTTPStatusCode'])
    except Exception as e:
        print(e)
        raise e

    # Copy to Datadog
    if is_log_to_be_forwarded_to_datadog(fullname=key, pattern=LOGS_PATTERNS_TO_BE_FORWARDED):
        event['Records'][0]['s3']['object']['key'] = target_key
        try:
            async_send_to_lambda(payload=event, target_lambda=DATADOG_FORWARDER_LAMBDA)
            print("Log forwarded to Datadog.")
        except Exception as e:
            print(e)
            pass

    return json.loads(json.dumps(response_copy, default=str))


def is_log_to_be_forwarded_to_datadog(fullname, pattern) -> bool:
    for each in pattern:
        if fullname is not None and each in fullname:
            return True
    return False


def async_send_to_lambda(payload, target_lambda):
    return function.invoke(
        FunctionName=target_lambda,
        InvocationType='Event',
        Payload=json.dumps(payload),
    )
