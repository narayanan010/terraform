import sys
import json
import os
import boto3
import requests
import logging


CWD = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, os.path.join(CWD, "libs"))

ACCOUNT_ALIAS = os.getenv("ACCOUNT_ALIAS")
WEBHOOK_SSM = os.getenv("WEBHOOK_SSM")
ACCOUNT_MAPPING_SSM = os.getenv("ACCOUNT_MAPPING_SSM")

ssm_client = boto3.client('ssm')
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


def find_by_id(account_mapping, account_id):
    loaded_mapping = json.loads(account_mapping)
    return loaded_mapping[account_id]
    

def handler(event, context):
    webhook_url = get_parameter_value(WEBHOOK_SSM)

    account_mapping = get_parameter_value(ACCOUNT_MAPPING_SSM)
    account_id = event["detail"]["awsAccountId"]
    
    try:
        account_alias = find_by_id(account_mapping, account_id)
    except:
        logger.error("Account Alias not found")
        account_alias = account_id
    
    logger.info(account_alias)
    
    slack_message_txt =  "Status" + "\t" + event["detail"]["newEvaluationResult"]["complianceType"] + "\n" + "Region" + "\t" + event["detail"]["awsRegion"] + "\n" +  "Resource Type" + "\t" + event["detail"]["newEvaluationResult"]["evaluationResultIdentifier"]["evaluationResultQualifier"]["resourceType"] + "\n" + "Resource ID" + "\t" +  event["detail"]["resourceId"]
    logger.info(slack_message_txt)    
    
    status = "danger"
    if event["detail"]["newEvaluationResult"]["complianceType"] == "COMPLIANT":
        status = "good"
    
    
    slack_message = {
        "attachments": [
            {
                "fallback": "AWS Compliance Issue Raised",
                "color": status,
                "pretext": "AWS Compliance Event: " + event["detail"]["configRuleName"] + " ```ACCOUNT_ALIAS: " + account_alias + "```",
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
