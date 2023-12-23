#from datetime import datetime
from logging import getLogger, INFO
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
import json
import os
import boto3


logger = getLogger()
logger.setLevel(INFO)

channel = os.environ['SLACK_CHANNEL_ID']
username = os.environ['SLACK_SUBJECT']
ssm_token = os.environ['SLACK_TOKEN']
ssm_client = boto3.client('ssm')

def get_parameter_value(parameter_name):
    try:
        response = ssm_client.get_parameter(
            Name=parameter_name,
            WithDecryption=True
        )
    except ssm_client.exceptions.ParameterNotFound:
        logger.error("Parameter not found")
    return response['Parameter']['Value']

def build_slack_message(event):
    """Slack message formatting"""    
    parsed_message = json.loads(event['Message'])
    
    slack_message = {
        'channel': channel,
        'username': username, 
        'text': event['Subject'],
        'icon_emoji': ':aws:',
        'attachments': [{ 
          'color': '#8697db', 
          'fields': [ 
            {
              'title': 'Description',
              'value': parsed_message['Description'],
              'short': True
            },
            {
              'title': 'Cause',
              'value': parsed_message['Cause'],
              'short': True
            }
          ]
        }]
    }
    
    return slack_message


def handler(event, context):
    response = 1
    
    slack_token = get_parameter_value(ssm_token)

    print(event)
    slack_event = event['Records'][0]['Sns']
    slack_message = build_slack_message(slack_event)

    headers = {
        'Authorization': 'Bearer ' + slack_token,
        'Content-Type': 'application/json',
    }

    req = Request('https://slack.com/api/chat.postMessage', headers=headers, data=json.dumps(slack_message).encode('utf-8'))
    try:
        with urlopen(req) as res:
            res.read()
            logger.info("Message posted.")
    except HTTPError as err:
        logger.error("Request failed: %d %s", err.code, err.reason)
    except URLError as err:
        logger.error("Server connection failed: %s", err.reason)
    else:
        response = 0

    return response