locals {
  kinesis_firehose_stream_name = "datadog-logs-stream"
}

data "aws_iam_policy_document" "kinesis_stream" {
  statement {
    sid     = "CloudWatch"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
  }

  statement {
    sid     = "Firehouse"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com", "streams.metrics.cloudwatch.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kinesis_stream" {
  name               = "DatadogLogsStreamRole"
  description        = "Role for Kinesis Stream"
  assume_role_policy = data.aws_iam_policy_document.kinesis_stream.json
}

resource "aws_iam_role_policy" "kinesis_stream" {
  name = "pol_kinesis"
  role = aws_iam_role.kinesis_stream.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AuthorizeFromAddress",
          "Effect" : "Allow",
          "Action" : [
            "firehose:PutRecord",
            "firehose:PutRecordBatch",
            "kinesis:PutRecord",
            "kinesis:PutRecords"
          ],
          "Resource" : "arn:aws:firehose:*:${data.aws_caller_identity.current.account_id}:deliverystream/*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "kinesis_stream02" {
  name = "pol_kinesis02"
  role = aws_iam_role.kinesis_stream.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "glue:GetTable",
            "glue:GetTableVersion",
            "glue:GetTableVersions"
          ],
          "Resource" : [
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/*",
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*/*"
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "glue:GetSchemaByDefinition"
          ],
          "Resource" : [
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:registry/*",
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:schema/*"
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "glue:GetSchemaVersion"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
          ],
          "Resource" : [
            "arn:aws:s3:::${aws_s3_bucket.codedeploy_bucket.id}",
            "arn:aws:s3:::${aws_s3_bucket.codedeploy_bucket.id}/*"
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "lambda:InvokeFunction",
            "lambda:GetFunctionConfiguration"
          ],
          "Resource" : "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:GenerateDataKey",
            "kms:Decrypt"
          ],
          "Resource" : [
            "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
          ],
          "Condition" : {
            "StringEquals" : {
              "kms:ViaService" : "s3.${data.aws_region.current.name}.amazonaws.com"
            },
            "StringLike" : {
              "kms:EncryptionContext:aws:s3:arn" : [
                "arn:aws:s3:::*/*",
                "arn:aws:s3:::*"
              ]
            }
          }
        },
        {
          "Sid" : "CloudWatchLogs",
          "Effect" : "Allow",
          "Action" : [
            "logs:*"
          ],
          "Resource" : [
            "arn:aws:logs:*"
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
          ],
          "Resource" : "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt"
          ],
          "Resource" : [
            "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
          ],
          "Condition" : {
            "StringEquals" : {
              "kms:ViaService" : "kinesis.${data.aws_region.current.name}.amazonaws.com"
            },
            "StringLike" : {
              "kms:EncryptionContext:aws:kinesis:arn" : "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/*"
            }
          }
        }
      ]
    }
  )
}


resource "aws_cloudwatch_metric_stream" "kinesis_stream" {
  name          = local.kinesis_firehose_stream_name # datadog-logs-stream
  role_arn      = aws_iam_role.kinesis_stream.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream.arn
  output_format = "opentelemetry0.7"

  statistics_configuration {
    additional_statistics = [
      "p50",
      "p80",
      "p95",
      "p99",
      "p99.9",
    ]

    include_metric {
      metric_name = "Duration"
      namespace   = "AWS/Lambda"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p50",
      "p90",
      "p95",
      "p99",
      "p99.9",
    ]

    include_metric {
      metric_name = "FirstByteLatency"
      namespace   = "AWS/S3"
    }
    include_metric {
      metric_name = "TotalRequestLatency"
      namespace   = "AWS/S3"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p50",
      "p90",
      "p95",
      "p99",
    ]

    include_metric {
      metric_name = "TargetResponseTime"
      namespace   = "AWS/ApplicationELB"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p50",
      "p95",
      "p99",
    ]

    include_metric {
      metric_name = "RequestLatency"
      namespace   = "AWS/AppRunner"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p50",
      "p99",
    ]

    include_metric {
      metric_name = "PostRuntimeExtensionsDuration"
      namespace   = "AWS/Lambda"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p90",
      "p95",
      "p99",
    ]

    include_metric {
      metric_name = "IntegrationLatency"
      namespace   = "AWS/ApiGateway"
    }
    include_metric {
      metric_name = "Latency"
      namespace   = "AWS/ApiGateway"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p90",
    ]

    include_metric {
      metric_name = "Latency"
      namespace   = "AWS/AppSync"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p95",
      "p99",
    ]

    include_metric {
      metric_name = "ActivityRunTime"
      namespace   = "AWS/States"
    }
    include_metric {
      metric_name = "ActivityScheduleTime"
      namespace   = "AWS/States"
    }
    include_metric {
      metric_name = "ActivityTime"
      namespace   = "AWS/States"
    }
    include_metric {
      metric_name = "ExecutionTime"
      namespace   = "AWS/States"
    }
    include_metric {
      metric_name = "LambdaFunctionRunTime"
      namespace   = "AWS/States"
    }
    include_metric {
      metric_name = "LambdaFunctionScheduleTime"
      namespace   = "AWS/States"
    }
    include_metric {
      metric_name = "LambdaFunctionTime"
      namespace   = "AWS/States"
    }
  }
  statistics_configuration {
    additional_statistics = [
      "p95",
      "p99",
    ]

    include_metric {
      metric_name = "Latency"
      namespace   = "AWS/ELB"
    }
    include_metric {
      metric_name = "TargetResponseTime"
      namespace   = "AWS/ELB"
    }
  }
}

data "aws_secretsmanager_secret_version" "datadog" {
  secret_id = "datadog-tf"
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  name        = local.kinesis_firehose_stream_name
  destination = "http_endpoint"

  http_endpoint_configuration {
    url                = var.datadog_http_endpoint
    name               = "Datadog"
    access_key         = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_key"]
    buffering_size     = 4
    buffering_interval = 60
    retry_duration     = 60
    role_arn           = aws_iam_role.kinesis_stream.arn
    s3_backup_mode     = "FailedDataOnly"

    s3_configuration {
      role_arn            = aws_iam_role.kinesis_stream.arn
      bucket_arn          = aws_s3_bucket.codedeploy_bucket.arn
      buffering_size      = 4
      buffering_interval  = 60
      error_output_prefix = "datadog_stream"
      compression_format  = "GZIP"
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${local.kinesis_firehose_stream_name}"
      log_stream_name = "DestinationDelivery"
    }

    processing_configuration {
      enabled = false
    }

    request_configuration {
      content_encoding = "NONE"
    }
  }

  server_side_encryption {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_agent" {
  name            = local.kinesis_firehose_stream_name
  role_arn        = aws_iam_role.kinesis_stream.arn
  log_group_name  = aws_cloudwatch_log_group.datadog_agent.id
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream.arn
  distribution    = "ByLogStream"

  depends_on = [aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream, aws_cloudwatch_log_group.datadog_agent]
}
