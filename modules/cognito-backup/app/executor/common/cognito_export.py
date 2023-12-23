def list_users_helper(client, pool_id, pagination_token):
    if pagination_token is not None:
        return client.list_users(
            UserPoolId=pool_id,
            PaginationToken=pagination_token
        )
    else:
        return client.list_users(
            UserPoolId=pool_id
        )


def write_to_file(file_path, pool_data):
    users = pool_data['Users']
    csv_headers = pool_data['CSVHeaders']
    header_string = ','.join(csv_headers)

    with open(file_path, 'w') as outfile:
        outfile.write(header_string + "\n")
        for user in users:
            user_string = None
            attributes = user['Attributes']
            for header in csv_headers:
                value = next((item['Value'] for item in attributes if item["Name"] == header), '')
                if header == 'cognito:username':
                    value = user['Username']
                if (header.lower().endswith('enabled') or header.lower().endswith('verified')) and value == '':
                    value = 'false'
                if user_string is None:
                    user_string = value
                else:
                    user_string = user_string + "," + value
            outfile.write(user_string + "\n")

    return True


def export_file(aws_client, pool_id, file_path, input_next_token, len_users_limit):
    pool_data = get_pool_data(aws_client, pool_id, input_next_token, len_users_limit)
    write_to_file(file_path, pool_data)
    return pool_data['PaginationToken']


def get_user_pool_name(aws_client, pool_id):
    response = aws_client.describe_user_pool(
        UserPoolId=pool_id
    )
    return (response['UserPool'])['Name']


def get_pool_data(aws_client, pool_id, input_next_token, len_users_limit):
    users = []

    response = aws_client.get_csv_header(
        UserPoolId=pool_id
    )
    csv_headers = response['CSVHeader']

    pagination_token = None
    if input_next_token != "null":
        pagination_token = input_next_token

    response = list_users_helper(aws_client, pool_id, pagination_token)
    users = users + response['Users']

    while 'PaginationToken' in response and len(users) < len_users_limit:
        pagination_token = response['PaginationToken']
        response = list_users_helper(aws_client, pool_id, pagination_token)
        users = users + response['Users']

    pagination_token = None
    if 'PaginationToken' in response:
        pagination_token = response['PaginationToken']

    return {
        "Users": users,
        "CSVHeaders": csv_headers,
        "PaginationToken": pagination_token
    }
