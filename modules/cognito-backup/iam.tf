# Lambda Executor IAM
data "aws_iam_policy_document" "backup_executor_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid = "S3"

    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.backup_storage.arn,
      "${aws_s3_bucket.backup_storage.arn}/*"
    ]
  }
}

resource "aws_iam_role" "backup_executor_lambda" {
  name_prefix        = "${var.vertical}-cognito-backup-executor-"
  assume_role_policy = data.aws_iam_policy_document.backup_executor_lambda_assume_role.json

  inline_policy {
    name   = "lambda_access_policy"
    policy = data.aws_iam_policy_document.s3_access.json
  }
}

resource "aws_iam_role_policy_attachment" "backup_executor_lambda_basic_execution" {
  role        = aws_iam_role.backup_executor_lambda.name
  policy_arn  = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "backup_executor_lambda_cognito_access" {
  role        = aws_iam_role.backup_executor_lambda.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}

# Lambda Selector IAM
data "aws_iam_policy_document" "backup_selector_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "backup_selector_lambda" {
  name_prefix        = "${var.vertical}-cognito-backup-selector-"
  assume_role_policy = data.aws_iam_policy_document.backup_selector_lambda_assume_role.json

}

resource "aws_iam_role_policy_attachment" "backup_selector_lambda_basic_execution" {
  role        = aws_iam_role.backup_selector_lambda.name
  policy_arn  = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "backup_selector_lambda_cognito_access" {
  role        = aws_iam_role.backup_selector_lambda.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}

###########
###########
# SFN

data "aws_iam_policy_document" "assume_role" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup_sfn" {
  count = local.create_role ? 1 : 0

  name_prefix           = "${var.vertical}-${var.environment}-cognito-backup-sfn-"
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json

  tags = merge(var.tags, var.role_tags)
}

data "aws_iam_policy_document" "backup_sfn" {
  statement {
    sid = "States"

    actions = [
      "states:*"
    ]

    resources = [
      aws_sfn_state_machine.this.arn
    ]
  }

  statement {
    sid = "Lambda"

    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      aws_lambda_function.backup_executor_lambda.arn,
      aws_lambda_function.backup_selector_lambda.arn
    ]
  }

  statement {
    sid = "S3"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]
    resources = ["${aws_s3_bucket.backup_storage.arn}/BackupProcessJobs/*"]
    
  }
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups",
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "backup_sfn" {
  name_prefix = "${var.vertical}-${var.environment}-cognito-backup-sfn-"
  policy      = data.aws_iam_policy_document.backup_sfn.json
}

resource "aws_iam_policy_attachment" "backup_sfn" {
  name       = aws_iam_role.backup_sfn[0].name
  roles      = [aws_iam_role.backup_sfn[0].name]
  policy_arn = aws_iam_policy.backup_sfn.arn
}


###########
###########
# EVENTBRIDGE

data "aws_iam_policy_document" "assume_eventbridge" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eventbridge" {

  name_prefix           = "${var.vertical}-${var.environment}-cognito-backup-event-"
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_eventbridge.json

}

data "aws_iam_policy_document" "eventbridge_trigger_sfn" {

  statement {
    sid       = "StepFunctionAccess"
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = [aws_sfn_state_machine.this.arn]
  }
}

resource "aws_iam_policy" "eventbridge_trigger_sfn" {
  name_prefix = "${var.vertical}-${var.environment}-cognito-backup-event-"
  policy      = data.aws_iam_policy_document.eventbridge_trigger_sfn.json
}

resource "aws_iam_policy_attachment" "eventbridge_trigger_sfn" {

  name       = "${var.vertical}-${var.environment}-cognito-backup-event"
  roles      = [aws_iam_role.eventbridge.name]
  policy_arn = aws_iam_policy.eventbridge_trigger_sfn.arn
}
