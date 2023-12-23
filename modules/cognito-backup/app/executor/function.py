import boto3
import os
import logging

from common.s3_upload import upload_file
from common.cognito_export import export_file
from common.utilities import build_object_name
from common.cognito_export import get_user_pool_name
from common.utilities import build_file_path
from common.utilities import build_file_name

cognito_client = boto3.client('cognito-idp')
s3_client = boto3.client('s3')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

BUCKET = os.getenv("BUCKET")
LENGTH_USERS_LIMIT = os.getenv("LENGTH_USERS_LIMIT")


def handler(event, context):
    logger.info(event)

    user_pool_id = event['Target']
    input_next_token = event['NextToken']
    chunk_number = event['ChunkNumber']

    file_name = build_file_name(user_pool_id, chunk_number)
    file_path = build_file_path(file_name)

    user_pool_name = get_user_pool_name(cognito_client, user_pool_id)
    object_name = build_object_name(file_name, user_pool_name)

    output_next_token = export_file(cognito_client, user_pool_id, file_path, input_next_token, int(LENGTH_USERS_LIMIT))
    logger.info("The output Token is: " + str(output_next_token))

    upload_file(s3_client, file_path, BUCKET, object_name, logger)

    response = {}
    chunk_number += 1
    response["Target"] = user_pool_id
    response["NextToken"] = output_next_token
    response["Completed"] = False
    response["ChunkNumber"] = chunk_number

    if output_next_token is None:
        response["NextToken"] = "null"
        response["Completed"] = True

    logger.info(response)
    return response
