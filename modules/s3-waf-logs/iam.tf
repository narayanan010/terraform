resource "aws_iam_role" "scalyr_logs_ingester" {
  name = "aws-waf-logs-${var.vertical}-${var.stage}-${var.region}"
  path = "/scalyr/"

  assume_role_policy = data.aws_iam_policy_document.scalyr_logs_ingester_remote_account.json

  inline_policy {
    name   = "get-logs-policy"
    policy = data.aws_iam_policy_document.get_waf_logs.json
  }

}


data "aws_iam_policy_document" "scalyr_logs_ingester_remote_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::913057016266:root"]
    }

    actions = [
      "sts:AssumeRole"
    ]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["6OPCD2SWWS3XIYZU76ZGJ2KCSZRMEQVD7F63OSBP6Q5O4LMTVSEQ===="]
    }

  }
}

data "aws_iam_policy_document" "get_waf_logs" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.waf_logs.arn}/*"]
  }
  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage"
    ]
    resources = [aws_sqs_queue.logs_notification.arn]
  }
}
