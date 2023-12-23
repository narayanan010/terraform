resource "aws_s3_bucket" "capterra-cloudfront-logs" {
  bucket        = "capterra-cloudfront-logs"
  force_destroy = "false"

  grant {
    id          = "c666fdbbf3adfcb6c0e6fe398bdb83fdfb151163b086c830a31fd8995272dc96" # 237884149494 capterra-aws-admin
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0" # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 0
    enabled                                = true
    id                                     = "Delete after 30 days"
    tags                                   = {}

    expiration {
      days                         = 30
      expired_object_delete_marker = false
    }
  }


  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  tags = {
    NAME = "capterra-cloudfront-logs"
  }
}


resource "aws_s3_bucket_policy" "capterra-cloudfront-logs" {
  bucket = aws_s3_bucket.capterra-cloudfront-logs.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Sid": "Capterra1SearchX1crfX1AccountsAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": [ "148797279579", "176540105868", "273213456764", "296947561675", "377773991577", "350125959894", "738909422062" ]
      },
      "Action": [
        "s3:GetBucketAcl",
        "s3:PutBucketAcl"
      ],
      "Resource": "${aws_s3_bucket.capterra-cloudfront-logs.arn}"
    },
    {
      "Sid": "Stmt1585387610192",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-cloudfront-logs.arn}",
                "${aws_s3_bucket.capterra-cloudfront-logs.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_lambda_function" "cloudfront_logs_partitioning" {
  filename      = "cloudfront_logs_partitioning.zip"
  function_name = "cloudfront_logs_partitioning"
  role          = aws_iam_role.cloudfront_logs_partitioning.arn
  handler       = "cloudfront_logs_partitioning.lambda_handler"
  description   = "Rename CloudFront log files to match partition projection format"

  source_code_hash = filebase64sha256("cloudfront_logs_partitioning.zip")

  runtime = "python3.9"
}


resource "aws_iam_role" "cloudfront_logs_partitioning" {
  name = "cloudfront_logs_partitioning"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name   = "cloudfront_logs_partitioning"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:PutObjectTagging",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "${aws_s3_bucket.capterra-cloudfront-logs.arn}/*"
        },
        {
            "Sid": "LambdaInvoke",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder-*"
        }
    ]
}
EOF
  }
}


resource "aws_lambda_permission" "cloudfront_logs_s3" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.cloudfront_logs_partitioning.arn
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.capterra-cloudfront-logs.arn
  source_account = data.aws_caller_identity.current.account_id
}


resource "aws_cloudwatch_log_group" "cloudfront_logs_partitioning" {
  name              = "/aws/lambda/${aws_lambda_function.cloudfront_logs_partitioning.function_name}"
  retention_in_days = 7
}


data "aws_ssm_parameter" "cloudfront_logs_push_to_newrelic_license_key" {
  name = "cloudfront_logs_push_to_newrelic_license_key"
}


resource "aws_lambda_function" "cloudfront_logs_push_to_newrelic" {
  filename      = "cloudfront_logs_push_to_newrelic.zip"
  function_name = "cloudfront_logs_push_to_newrelic"
  handler       = "cloudfront_logs_push_to_newrelic.lambda_handler"
  role          = aws_iam_role.cloudfront_logs_push_to_newrelic.arn
  timeout       = 900
  memory_size   = 384
  description   = "Send log data from a S3 bucket to New Relic Logging."

  source_code_hash = filebase64sha256("cloudfront_logs_push_to_newrelic.zip")

  runtime = "python3.8"

  environment {
    variables = {
      LICENSE_KEY   = data.aws_ssm_parameter.cloudfront_logs_push_to_newrelic_license_key.value
      LOG_TYPE      = ""
      DEBUG_ENABLED = "false"
    }
  }

  tags = {
    Author          = "New Relic"
    SpdxLicenseId   = "Apache-2.0"
    LicenseUrl      = "https://github.com/newrelic/aws_s3_log_ingestion_lambda/blob/758bfc6b679a2a9af93ff481d20f5a2aa6710c57/LICENSE"
    HomePageUrl     = "https://github.com/newrelic/aws_s3_log_ingestion_lambda"
    SemanticVersion = "1.1.1"
    SourceCodeUrl   = "https://github.com/newrelic/aws_s3_log_ingestion_lambda"
  }
}


resource "aws_iam_role" "cloudfront_logs_push_to_newrelic" {
  name = "cloudfront_logs_push_to_newrelic"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name   = "cloudfront_logs_push_to_newrelic"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "${aws_s3_bucket.capterra-cloudfront-logs.arn}/*"
        }
    ]
}
EOF
  }
}


resource "aws_lambda_permission" "cloudfront_logs_push_to_newrelic" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.cloudfront_logs_push_to_newrelic.arn
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.capterra-cloudfront-logs.arn
  source_account = data.aws_caller_identity.current.account_id
}


resource "aws_cloudwatch_log_group" "cloudfront_logs_push_to_newrelic" {
  name              = "/aws/lambda/${aws_lambda_function.cloudfront_logs_push_to_newrelic.function_name}"
  retention_in_days = 7
}


resource "aws_s3_bucket_notification" "cloudfront-logs" {
  bucket = aws_s3_bucket.capterra-cloudfront-logs.id

  lambda_function {
    id                  = "cloudfront-logs-new"
    lambda_function_arn = aws_lambda_function.cloudfront_logs_partitioning.arn
    events              = ["s3:ObjectCreated:Put"]
  }

  lambda_function {
    id                  = "cloudfront-logs-push-to-newrelic-reviews-softwareadvice"
    lambda_function_arn = aws_lambda_function.cloudfront_logs_push_to_newrelic.arn
    events              = ["s3:ObjectCreated:Copy"]
    filter_prefix       = "738909422062/EQXIR6ZYUOPZ8/"
  }

  lambda_function {
    id                  = "cloudfront-logs-push-to-newrelic-faas"
    lambda_function_arn = aws_lambda_function.cloudfront_logs_push_to_newrelic.arn
    events              = ["s3:ObjectCreated:Copy"]
    filter_prefix       = "296947561675/EDO5OM65X7JWC/"
  }

  lambda_function {
    id                  = "cloudfront-logs-push-to-newrelic-global-nav-mf"
    lambda_function_arn = aws_lambda_function.cloudfront_logs_push_to_newrelic.arn
    events              = ["s3:ObjectCreated:Copy"]
    filter_prefix       = "296947561675/EUHWSSBQHTTUA/"
  }

  lambda_function {
    id                  = "cloudfront_logs_clicks.capterra.com"
    lambda_function_arn = aws_lambda_function.cloudfront_logs_push_to_newrelic.arn
    events              = ["s3:ObjectCreated:Copy"]
    filter_prefix       = "296947561675/E2Y9ZN4ETNHYKU/"
  }

  lambda_function {
    id                  = "cloudfront_logs_clicks.capstage.net"
    lambda_function_arn = aws_lambda_function.cloudfront_logs_push_to_newrelic.arn
    events              = ["s3:ObjectCreated:Copy"]
    filter_prefix       = "273213456764/EDIN03EWVM6B1/"
  }

}
