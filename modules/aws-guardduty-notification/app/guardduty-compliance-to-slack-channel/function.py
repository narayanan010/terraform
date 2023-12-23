import sys
import json
import os
import boto3
import requests
import logging


CWD = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(CWD, "libs"))

WEBHOOK_SSM = os.getenv("WEBHOOK_SSM")
ACCOUNT_MAPPING_SSM = os.getenv("ACCOUNT_MAPPING_SSM")

ssm_client = boto3.client('ssm')
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_parameter_value(parameter_name):
    logger.info(parameter_name)
    try:
        response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=True
        )
        response['Parameter']['Value']
    except ssm_client.exceptions.ParameterNotFound:
        logger.error("Parameter not found")
    return response['Parameter']['Value']


def find_by_id(account_mapping, account_id):
    loaded_mapping = json.loads(account_mapping)
    return loaded_mapping[account_id]
    

def handler(event, context):
    webhook_url = get_parameter_value(WEBHOOK_SSM)

    account_id = event["detail"]["accountId"]
    
    try:
        account_mapping = get_parameter_value(ACCOUNT_MAPPING_SSM)
        account_alias = find_by_id(account_mapping, account_id)
    except:
        logger.error("Account Alias not found")
        account_alias = account_id
    
    logger.info(account_alias)

    finding = event["detail"]["type"]
    findingDescription = event["detail"]["description"]
    region = event["detail"]["region"]
    findingTime = event["detail"]["updatedAt"]
    severity = event["detail"]["severity"]

    if severity < 4.0:
        severityMark = 'Low'
        color = '#e2d43b'
    elif severity < 7.0:
        severityMark = 'Medium'
        color = '#ff8c00'
    elif severity >= 7.0:
        severityMark = 'High'
        color = '#ad0614'

    slack_message_txt =  "Severity" + "\t" + str(severity) + "\n" + "Finding" + "\t" + finding + "\n" + "Region" + "\t" + region + "\n" +  "Description" + "\t" + findingDescription + "\n" +  "Time" + "\t" + findingTime
    logger.info(slack_message_txt)    

    slack_message = {
        "attachments": [
            {
                "fallback": "AWS Guarduty Finding",
                "color": color,
                "severity": severityMark,
                "pretext": "AWS Guarduty Finding: " + finding + " ```ACCOUNT_ALIAS: " + account_alias + "```",
                "text": str(slack_message_txt)       
            }
        ]
    }
    
    logger.info("Slack Message: " + str(slack_message))

    r = requests.post(
        webhook_url,
        json = slack_message,
        headers={'Content-Type': 'application/json'}
    )
    logger.info(r)