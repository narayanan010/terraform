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
        },
        {
            "Sid": "SecretsMountAccess1",
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
                    "aws:ResourceTag/team": "${team_tag_1}"
                }
            }
        },
        {
            "Sid": "ParametersMountAccess",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": [
                "arn:aws:ssm:*:*:parameter/${team_tag_0}/${environment}/*",
                "arn:aws:ssm:*:*:parameter/${team_tag_1}/${environment}/*"]
        },
        {
            "Sid": "DynamoAccess",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem",
                "dynamodb:PutItem",
                "dynamodb:DescribeTable",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:UpdateItem",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeStream",
                "dynamodb:GetRecords"
            ],
            "Resource": [
                "arn:aws:dynamodb:us-east-1:350125959894:table/FeatureRatings",
                "arn:aws:dynamodb:us-east-1:350125959894:table/FeatureRatings*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/PartialReviews",
                "arn:aws:dynamodb:us-east-1:350125959894:table/PartialReviews*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ProductsReviews",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ProductsReviews*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ReviewIdCounter",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ReviewIdCounter*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/Timestamps",
                "arn:aws:dynamodb:us-east-1:350125959894:table/Timestamps*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedProductsReviews",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedProductsReviews*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedReviewTokens",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedReviewTokens*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/FeatureRatings/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/FeatureRatings*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/FeatureRatings/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/FeatureRatings*/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/PartialReviews/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/PartialReviews*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/PartialReviews/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/PartialReviews*/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ProductsReviews/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ProductsReviews*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ProductsReviews/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ProductsReviews*/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ReviewIdCounter/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ReviewIdCounter*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ReviewIdCounter/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/ReviewIdCounter*/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/Timestamps/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/Timestamps*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/Timestamps/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/Timestamps*/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedProductsReviews/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedProductsReviews*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedProductsReviews/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedProductsReviews*/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedReviewTokens/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedReviewTokens*/stream/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedReviewTokens/index/*",
                "arn:aws:dynamodb:us-east-1:350125959894:table/UpdatedReviewTokens*/index/*"
            ]
        },
        {
            "Sid": "s3Access",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Describe*",
                "s3:Put*"
            ],
            "Resource": [
                "arn:aws:s3:::crf-staging-cdn",
                "arn:aws:s3:::crf-staging-cdn/*"
            ]
        },
        {
            "Sid": "OtherAccess",
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "sns:Publish",
                "ses:SendRawEmail",
                "sns:CreateTopic",
                "sns:Subscribe",
                "lambda:InvokeFunction"
            ],
            "Resource": "*"
        }
    ]
}