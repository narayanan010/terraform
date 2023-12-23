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
                    "kms:ResourceAliases": "alias/secrets-manager/confluent/developers/prod"
                }
            }
        }
    ]
}