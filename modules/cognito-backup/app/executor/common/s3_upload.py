from botocore.exceptions import ClientError


def upload_file(s3_client, file_path, bucket, object_name, logger):
    try:
        s3_client.upload_file(file_path, bucket, object_name)
    except ClientError as e:
        logger.error(e)
        return False
    return True
