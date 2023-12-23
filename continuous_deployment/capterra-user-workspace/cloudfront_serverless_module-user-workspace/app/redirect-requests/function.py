import json


def handler(event, context):

    # Extracting the host could only work with a caching behaviour in which the host header is whitelisted
    # Without that particular caching behaviour the following host would be the one of S3 (Cloudfront substitute it.)
    host = event['Records'][0]['cf']['request']['headers']['host'][0]['value']
    redirect_url = "https://" + str(host) + "/workspace/index.html"

    # Generate HTTP redirect response with 302 status code and Location header.
    response = {
        'status': '302',
        'statusDescription': 'Found',
        'headers': {
            'location': [{
                'key': 'Location',
                'value': redirect_url
            }]
        }
    }

    return response