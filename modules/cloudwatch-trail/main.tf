data "aws_caller_identity" "current" {}

provider "aws" {
#  region = "${var.region_aws}"
  alias = "awscaller_account"
}

#This section is for common lambda that sends notification to slack security channel#################################
resource "aws_lambda_function" "alf-slack" {
provider      = "aws.awscaller_account"
#filename      = "slacksecurity_payload.zip"
filename       = "${path.module}/slacksecurity_payload.zip"
  function_name = "tf-slack-channel-security-lambda"
  role          = "${aws_iam_role.air-sns.arn}"
  handler       = "slacksecurity.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #source_code_hash = "${base64sha256(file("slacksecurity_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/slacksecurity_payload.zip")}"

  runtime = "${var.runtime_lambda}"

  environment {
    variables = {
      WEBHOOK_URL = "${var.slack_channel_webhook}"
    }
  }
  tags = {
        terraform_managed = "true"      
    }
}
resource "aws_lambda_permission" "alp-slack-sns" {
provider      = "aws.awscaller_account"
  statement_id  = "AllowExecutionFromSNS"
  action    = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.alf-slack.function_name}"
  principal   = "events.amazonaws.com"
  source_arn  = "${aws_sns_topic.ast.arn}"
}

resource "aws_lambda_permission" "alp-lambda-sns" {
provider      = "aws.awscaller_account"
  statement_id  = "AllowLambdaExecutionFromSNS"
  action    = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.alf-slack.function_name}"
  principal   = "sns.amazonaws.com"
  source_arn  = "${aws_sns_topic.ast.arn}"
}

resource "aws_iam_role" "air-sns" {
provider      = "aws.awscaller_account"
  name_prefix = "tf-lambda_with_sns"

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
}

#This section configures Cloudwatch rules and associates Cloudwatch with API trails and events. In future to add other new AWS CW rules, Append to Below section.
#This section is for EC2 API calls like SG creation, ingress, egress rules etc.###########################
resource "aws_cloudwatch_event_target" "acet-sns-ec2" {
provider      = "aws.awscaller_account"
  target_id = "acet-sns-ec2"
  rule      = "${aws_cloudwatch_event_rule.acer-sns-ec2.name}"
  arn       = "${aws_sns_topic.ast.arn}"
}
resource "aws_cloudwatch_event_rule" "acer-sns-ec2" {
provider      = "aws.awscaller_account"
  name        = "tf-cw-event-cloudtrail-ec2"
  description = "Event for Cloudtrail to log ec2,SG api calls"

  event_pattern = <<PATTERN
{
  "detail": {
    "eventName": [
      "AuthorizeSecurityGroupIngress",
      "AuthorizeSecurityGroupEgress",
      "RevokeSecurityGroupIngress",
      "RevokeSecurityGroupEgress",
      "CreateSecurityGroup",
      "DeleteSecurityGroup",
      "CreateNetworkAclEntry",
      "DeleteNetworkAclEntry",
      "TerminateInstances",
      "StopInstances"
    ]
  },
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.ec2"
  ]
}
PATTERN
}

#This section is for IAM api calls.
resource "aws_cloudwatch_event_target" "acet-sns-iam" {
provider      = "aws.awscaller_account"
  target_id = "acet-sns-iam"
  rule      = "${aws_cloudwatch_event_rule.acer-sns-iam.name}"
  arn       = "${aws_sns_topic.ast.arn}"
}
resource "aws_cloudwatch_event_rule" "acer-sns-iam" {
provider      = "aws.awscaller_account"
  name        = "tf-cw-event-cloudtrail-iam"
  description = "Event for Cloudtrail to log iam api calls"

  event_pattern = <<PATTERN
{
  "detail": {
    "eventSource": [
      "iam.amazonaws.com"
    ]
  },
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.iam"
  ]
}
PATTERN
}

#This section is for other API calls we want to monitor.#######################
resource "aws_cloudwatch_event_target" "acet-sns-misc" {
provider      = "aws.awscaller_account"
  target_id = "acet-sns-misc"
  rule      = "${aws_cloudwatch_event_rule.acer-sns-misc.name}"
  arn       = "${aws_sns_topic.ast.arn}"
}
resource "aws_cloudwatch_event_rule" "acer-sns-misc" {
provider      = "aws.awscaller_account"
  name        = "tf-cw-event-cloudtrail-misc"
  description = "Event for Cloudtrail to log misc api calls, we want to monitor"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventName": [
      "CreateHostedZone",
      "DeleteHealthCheck",
      "DeleteHostedZone",
      "DisassociateVPCFromHostedZone",
      "ChangeResourceRecordSets",
      "UpdateHealthCheck",
      "DisassociateVPCFromHostedZone",
      "CreateTrail",
      "DeleteTrail",
      "StartLogging",
      "StopLogging",
      "UpdateTrail",
      "AcceptVpcPeeringConnection"
    ]
  }
}
PATTERN
}

#This section configures SNS and topic and auto confirms it.########################
resource "aws_sns_topic" "ast" {
provider      = "aws.awscaller_account"
  name = "${var.sns_topic_name}"
}
resource "aws_sns_topic_subscription" "sns-topic" {
provider      = "aws.awscaller_account"
  topic_arn = "${aws_sns_topic.ast.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.alf-slack.arn}"
  endpoint_auto_confirms = "true"
}

#This section configures access policy required for sending messages to target i.e sns subscription here via Cloudwatch Events.####################
resource "aws_sns_topic_policy" "default" {
provider      = "aws.awscaller_account"
  arn = "${aws_sns_topic.ast.arn}"

  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}
data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "${var.aws_account_id}",
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "${aws_sns_topic.ast.arn}",
    ]

    sid = "__default_statement_ID"
  }

  statement{
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"
    resources = [
      "${aws_sns_topic.ast.arn}",
    ]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    sid = "tf-cw-event-sns-policy"

  }
}

#This section is responsible for configuring Cloudtrail and dependent resources###############################

resource "aws_cloudtrail" "act" {
provider      = "aws.awscaller_account"
#The data.aws_caller_identity.current.account_id always returns root account ID not assume_role account_id when fetched automatically. This is bug in terraform provider. https://github.com/terraform-providers/terraform-provider-aws/issues/386
  #name                          = "tf-cloudtrail-${data.aws_caller_identity.current.account_id}"
  name                          = "tf-cloudtrail-${var.aws_account_id}"
  #We will be using single bucket for logs in the AWS admin account for all other aws accounts, so putting the bucket name from admin account. Ensure that the S3 bucket policy for bucket in admin account has PutObject allowed for Cross-Account Log writing. Refer https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-set-bucket-policy-for-multiple-accounts.html for details
  #s3_bucket_name                = "${aws_s3_bucket.as3b-ct.id}"
  s3_bucket_name                = "capterra-cloudtrail-logs"
  include_global_service_events = true
  is_multi_region_trail   = true
  #The data.aws_caller_identity.current.account_id always returns root account ID not assume_role account_id when fetched automatically. This is bug in terraform provider.
  #cloud_watch_logs_group_arn  = "arn:aws:logs:${var.region_aws}:${data.aws_caller_identity.current.account_id}:log-group:CloudTrail/tf-AuditLogGroup:*"
  #cloud_watch_logs_group_arn  = "arn:aws:logs:${var.region_aws}:${var.aws_account_id}:log-group:CloudTrail/tf-AuditLogGroup:*"
  cloud_watch_logs_group_arn  = "arn:aws:logs:${var.region_aws}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.tf-AuditLogGroup.name}:*"
  #cloud_watch_logs_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/tf-CloudTrail_CloudWatchLogs_Role"
  #cloud_watch_logs_role_arn   = "arn:aws:iam::${var.aws_account_id}:role/tf-CloudTrail_CloudWatchLogs_Role"
  cloud_watch_logs_role_arn   = "${aws_iam_role.tf-CloudTrail_CloudWatchLogs_Role.arn}"

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
}
}

#Though we are using bucket from AWS admin account, we are still creating a new bucket in the account where trail is created; in order to have it pre-configured and use it in future if needed.
resource "aws_s3_bucket" "as3b-ct" {
provider      = "aws.awscaller_account"
#The data.aws_caller_identity.current.account_id always returns root account ID not assume_role account_id when fetched automatically. This is bug in terraform provider.
  #bucket        = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  bucket        = "${var.bucket_name}-${var.aws_account_id}"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name}-${var.aws_account_id}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}-${var.aws_account_id}/AWSLogs/${var.aws_account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role" "tf-CloudTrail_CloudWatchLogs_Role" {
provider      = "aws.awscaller_account"
  name_prefix = "tf-CTrail_Cwatch_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    terraform_managed = "true"
  }
}

resource "aws_iam_role_policy" "policy" {
provider      = "aws.awscaller_account"
  name_prefix = "cloudtrail_cloudwatch_events_policy"
  role        = "${aws_iam_role.tf-CloudTrail_CloudWatchLogs_Role.id}"
  policy      = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:aws:logs:${var.region_aws}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.tf-AuditLogGroup.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${var.region_aws}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.tf-AuditLogGroup.name}:log-stream:*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "tf-AuditLogGroup" {
provider      = "aws.awscaller_account"
  #name = "tf-AuditLogGroup"
  name_prefix = "CloudTrail/tf-AuditLogGroup"

  tags = {
    terraform_managed = "true"
    Service = "Cloudtrail"
  }
}

resource "aws_cloudwatch_log_stream" "acls-ct" {
provider      = "aws.awscaller_account"
  name           = "ct-logstream"
  log_group_name = "${aws_cloudwatch_log_group.tf-AuditLogGroup.name}"
}