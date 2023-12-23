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
                    "aws:ResourceTag/team": "sauron"
                }
            }
        },
        {
			"Sid": "SQSReadWrite",
			"Effect": "Allow",
			"Action": [
				"sqs:DeleteMessage",
				"sqs:GetQueueUrl",
				"sqs:ChangeMessageVisibility",
				"sqs:ReceiveMessage",
				"sqs:SendMessage",
				"sqs:GetQueueAttributes",
				"sqs:ListQueueTags",
				"sqs:ListDeadLetterSourceQueues",
				"sqs:PurgeQueue",
				"sqs:DeleteQueue",
				"sqs:CreateQueue",
				"sqs:SetQueueAttributes"
			],
			"Resource": [
				"arn:aws:sqs:us-east-1:176540105868:ga360-uploader-stage",
				"arn:aws:sqs:us-east-1:176540105868:ga360-uploader-errors-stage"
			]
		},
		{
			"Sid": "SQSList",
			"Effect": "Allow",
			"Action": "sqs:ListQueues",
			"Resource": "*"
		}
    ]
}