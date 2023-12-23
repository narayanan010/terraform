import sys
import json
import os
import boto3
import requests
import logging


CWD = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(CWD, "libs"))

WEBHOOK_SSM = os.getenv("WEBHOOK_SSM")
APPLICATION = os.getenv("APPLICATION")
ENVIRONMENT = os.getenv("ENVIRONMENT")
QUEUE_URL = os.getenv("QUEUE_URL")

ssm_client = boto3.client('ssm')
sqs_client = boto3.client('sqs')
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_parameter_value(parameter_name):
    try:
        response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=True
        )
    except ssm_client.exceptions.ParameterNotFound:
        logger.error("Parameter not found")
    return response['Parameter']['Value']


def send_message_to_queue(event_message, queue_url):
    response = sqs_client.send_message(
        QueueUrl=queue_url,
        MessageBody=str(event_message["body"]),
        MessageDeduplicationId=event_message["attributes"]["MessageDeduplicationId"],
        MessageGroupId=event_message["attributes"]["MessageGroupId"]
    )
    return response


def handler(event, context):
    webhook_url = get_parameter_value(WEBHOOK_SSM)

    pretext = APPLICATION + " " + ENVIRONMENT + " - EVENT PROCESSING FAILED"
    for event_message in event['Records']:
        logger.info(event_message)
        message_id = str(event_message["messageId"])
        message_body = str(event_message["body"])
        message_handle = str(event_message["receiptHandle"])

        message = {
            "attachments": [
                {
                    "fallback": "Event Processing Issue Raised",
                    "color": "danger",
                    "pretext": pretext,
                    'text': "MessageId: %s\nBody: %s\nReceiptHandle: %s" % (message_id, message_body, message_handle)
                }
            ]
        }
        
        r = requests.post(
            webhook_url,
            json = message,
            headers={'Content-Type': 'application/json'}
        )
        
        logger.info(r)

        return send_message_to_queue(event_message, QUEUE_URL)
