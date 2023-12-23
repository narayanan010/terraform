{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SecretsMountAccess0",
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
                    "aws:ResourceTag/team": "${team_tag_0}"
                }
            }
        }
    ]
}