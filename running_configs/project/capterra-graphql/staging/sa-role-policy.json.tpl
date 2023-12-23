{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SecretsManager",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/environment": "${environment}"
                },
                "StringLike": {
                    "aws:ResourceTag/team": "daylight"
                }
            }
        },
        {
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:932799032166:secret:/applications/qa/qa/confluent/svc.bx.bx-api-graphql/api_keys-bhZ3rN"
            ],
            "Sid": "Stmt1680771318"
        },
        {
            "Sid": "KmsAccess3",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "ForAnyValue:StringEquals": {
                    "kms:ResourceAliases": "alias/secrets-manager/confluent/developers/qa"
                }
            }
        }
    ]
}