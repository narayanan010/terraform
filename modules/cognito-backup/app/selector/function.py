import boto3
import logging
import datetime

cognito_client = boto3.client('cognito-idp')
cognito_paginator = cognito_client.get_paginator('list_user_pools')
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):

    response = {}
    target_pool_ids = []
    logger.info(datetime.datetime.now().strftime("%Y-%m-%d %H-%M-%S") + " - Selecting Cognito backup targets")
    for page in cognito_paginator.paginate(PaginationConfig={"PageSize": 60}):
        for pool in page['UserPools']:
            cognito_response = cognito_client.describe_user_pool(
                UserPoolId=pool['Id']
            )
            tags = cognito_response['UserPool']['UserPoolTags']
            if 'backup' in tags and tags['backup'] == 'true':
                logger.info("Match: " + pool['Id'])
                target_pool_ids.append(pool['Id'])
    
    response["list_targets"] = target_pool_ids
    logger.info("Forwarding response: " + str(response))
    return response