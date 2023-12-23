#Created By: Capterra Cloud DevOps Team (Colin/Sarvesh/Dan)
#Date: 07/17/2020
#Last update: 16/08/2022
#Purpose: The purpose of this function is to set the default Cloudwatch Log Group to value specified in retention_days variable

import json
import boto3
import os
    
def lambda_handler(event, context):
    retention_days = int(os.getenv("RETENTION_DAYS"))       # set the number of retention days
    cw_excluded = os.getenv("CLOUDWATCH_LG_EXCLUDED")       # desired Cloudwatch Log Group to exclude from retention policy
    cw_lambda = os.getenv("CLOUDWATCH_LG_LAMBDA")           # default Lambda CW_logroup
    # print ('CLOUDWATCH_LG_EXCLUDED: ', cw_excluded)       # debug
    # print ('CLOUDWATCH_LG_LAMBDA: ', cw_lambda)           # debug
    regions=['us-east-1']                                   # list the regions you are interested to run this script on

    for region in regions:
        client = boto3.client('logs',region)
        response = client.describe_log_groups(
        )
        nextToken=response.get('nextToken',None)
        retention = response['logGroups']
        while (nextToken is not None):
            response = client.describe_log_groups(
                nextToken=nextToken
            )
            nextToken = response.get('nextToken', None)
            retention = retention + response['logGroups']
        for group in retention:
            if (group['logGroupName'] == cw_lambda) or (cw_excluded.find(group['logGroupName'])!=-1):
                print ('This Log Group will be excluded: ', group['logGroupName'])
                continue    # skip this log group

            if 'retentionInDays' in group.keys():
                #print (group.keys())
                print(group['logGroupName'], group['retentionInDays'],region)
                if retention_days == group['retentionInDays']:
                    print ('Retention found is equal to desired value for LogGroup',group['logGroupName'])
                else:
                    print("Retention found is not equal to desired value for LogGroup ",group['logGroupName'],region)
                    print ('Updating Retention Days to: ' +os.getenv("RETENTION_DAYS")+ ' days.  Previous Retention was set to days:',group['retentionInDays'])
                    setretention = client.put_retention_policy(
                        logGroupName=group['logGroupName'],
                        retentionInDays=retention_days
                        )
                    # print ('Set new retention: ', setretention) # debug
            else:
                print("Retention Not found for ",group['logGroupName'],region)
                print("Updating Retention Days for ",group['logGroupName'],region)
                setretention = client.put_retention_policy(
                    logGroupName=group['logGroupName'],
                    retentionInDays=retention_days
                    )
                # print ('Set new retention: ', setretention) # debug