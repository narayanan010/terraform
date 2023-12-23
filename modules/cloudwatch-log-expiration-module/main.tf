#################################################################################
# Terraform Code for Setting Retention_Days to CW-Log-Groups across AWS accounts
# Once lambda is deployed it will run once daily as CW cron schedule.
# This module will:
## Create lambda function that will set CW log group expiration in AWS Accounts.
## Create IAM roles with required permissions.
## Create CW logGroups and logstream for current lambda that is deployed.
## Create Daily CW-Cron schedule to trigger lambda that is deployed
#################################################################################

##This section is for lambda deployment that updates cloudwatch log groups with Expiration/Retention Days#################################

data "archive_file" "cloudwatch_log_group_expiration_zip" {
  type             = "zip"
  output_path      = "${path.module}/source/function.zip"
  source_file      = "${path.module}/source/cloudwatch_log_group_expiration.py"
  output_file_mode = "0666"
}

resource "aws_lambda_function" "lambda_cw_log_group" {
  description      = "Lambda function to update the Retention_days to CW_Logs_Group in AWS accounts. Managed by Terraform."
  filename         = data.archive_file.cloudwatch_log_group_expiration_zip.output_path
  function_name    = "tf-set-cloudwatch_logs_group_expiration"
  handler          = "cloudwatch_log_group_expiration.lambda_handler"
  source_code_hash = data.archive_file.cloudwatch_log_group_expiration_zip.output_base64sha256
  role             = aws_iam_role.tf-lambda_CloudWatchLogs_Role.arn
  runtime          = var.runtime_lambda
  timeout          = var.lambda_timeout

  environment {
    variables = {
      RETENTION_DAYS         = var.retention_days
      CLOUDWATCH_LG_LAMBDA   = aws_cloudwatch_log_group.tf-cloudwatch_log_group.name # default Lambda CW_logroup
      CLOUDWATCH_LG_EXCLUDED = join(",", var.cw_loggroups_excluded)
    }
  }
}



##Cloudwatch log-group and log-stream Creation##########################################################

resource "aws_cloudwatch_log_group" "tf-cloudwatch_log_group" {
  name = "/aws/lambda/tf-set-cloudwatch_logs_group_expiration"
  #retention_in_days = var.retention_days
  retention_in_days = "30"
}

resource "aws_cloudwatch_log_stream" "acls-cw" {
  name           = "cw-logstream"
  log_group_name = aws_cloudwatch_log_group.tf-cloudwatch_log_group.name
}



##Permission/Role/Policies Creation/Attachment for current lambda's log group###########################

resource "aws_iam_role" "tf-lambda_CloudWatchLogs_Role" {
  name_prefix = "tf-lambda_CloudWatchLogs_Role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "lambda_execution" {
  name_prefix = "tf-cw_loggroup_pol"
  role        = aws_iam_role.tf-lambda_CloudWatchLogs_Role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:CreateLogGroup"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "airpa1" {
  role       = aws_iam_role.tf-lambda_CloudWatchLogs_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}


##Setup CW Cron schedule and lambda target with permissions##################################

resource "aws_cloudwatch_event_rule" "cw_schedule_daily" {
  name                = "tf-cw_set-cloudwatch-log-group-expiration_cron"
  description         = "This is CW cron to trigger lambda set-cloudwatch-log-group-expiration"
  schedule_expression = "cron(59 11 ? * * *)"
  is_enabled          = var.eventbridge_rule_enabled ? true : false
}

resource "aws_cloudwatch_event_target" "target_cw_schedule_daily" {
  rule      = aws_cloudwatch_event_rule.cw_schedule_daily.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda_cw_log_group.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_cron" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_cw_log_group.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cw_schedule_daily.arn
}
