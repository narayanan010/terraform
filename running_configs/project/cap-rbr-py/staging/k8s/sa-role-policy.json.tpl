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
                    "aws:ResourceTag/environment": "staging"
                },
                "StringLike": {
                    "aws:ResourceTag/team": "frodo"
                }
            }
        },
	{
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::gdm-de-unload-qa",
                "arn:aws:s3:::gdm-de-unload-qa/*"
            ],
            "Effect": "Allow",
            "Sid": "GDMS3BucketActions"
	},
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::ppc-rankins-exports-staging"
            ],
            "Effect": "Allow",
            "Sid": "CapterraS3BucketActions"
        }
    ]
}
