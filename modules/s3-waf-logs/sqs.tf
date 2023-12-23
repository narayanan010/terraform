resource "aws_sqs_queue" "logs_notification" {
  name                      = "aws-waf-logs-${var.vertical}-${var.stage}-${var.region}"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  sqs_managed_sse_enabled   = true
}

resource "aws_sqs_queue_policy" "logs_notification" {
  queue_url = aws_sqs_queue.logs_notification.id
  policy    = data.aws_iam_policy_document.default_sqs.json
}

data "aws_iam_policy_document" "default_sqs" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "SQS:*"
    ]

    resources = [
      aws_sqs_queue.logs_notification.arn
    ]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = [
      "SQS:SendMessage"
    ]

    resources = [
      aws_sqs_queue.logs_notification.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }


    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.waf_logs.arn]
    }
  }
}
