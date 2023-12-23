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
                    "aws:ResourceTag/Environment": "prod"
                },
                "StringLike": {
                    "aws:ResourceTag/Team": "Frodo"
                }
            }
        },
        {
            "Action": [
                "s3:ListBucket*",
                "s3:ListAllMyBuckets",
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::autobidder-prod",
                "arn:aws:s3:::autobidder-prod/*"
            ],
            "Effect": "Allow",
            "Sid": "s3"
        }
    ]
}