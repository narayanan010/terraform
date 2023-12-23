locals {
  create_role = var.create_role && !var.use_existing_role

  enable_logging = try(var.logging_configuration["level"], "OFF") != "OFF"

  enable_xray_tracing = try(var.service_integrations["xray"]["xray"], false) == true

  # Normalize ARN by trimming ":*" because data-source has it, but resource does not have it
  log_group_arn = trimsuffix(try(data.aws_cloudwatch_log_group.sfn[0].arn, aws_cloudwatch_log_group.sfn[0].arn, ""), ":*")

  definition = <<EOF
{
  "Comment": "An example of the Amazon States Language using a choice state.",
  "StartAt": "SelectTargets",
  "States": {
    "SelectTargets": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.backup_selector_lambda.arn}",
      "Next": "ParallelBackup"
    },
    "ParallelBackup": {
      "Type": "Map",
      "ItemsPath": "$.list_targets",
      "Parameters": {
        "Target.$": "$$.Map.Item.Value"
      },
      "ItemProcessor": {
        "ProcessorConfig": {
          "Mode": "DISTRIBUTED",
          "ExecutionType": "STANDARD"
        },
        "StartAt": "AddStatus",
        "States": {
          "AddStatus": {
            "Type": "Pass",
            "Next": "CheckIfCompleted",
            "Parameters": {
              "Target.$": "$.Target",
              "Completed": false,
              "NextToken": "null",
              "ChunkNumber": 0
            },
            "ResultPath": "$"
          },
          "CheckIfCompleted": {
            "Type": "Choice",
            "Choices": [
              {
                "Variable": "$.Completed",
                "BooleanEquals": true,
                "Next": "Succeed"
              }
            ],
            "Default": "ExecuteBackup"
          },
          "ExecuteBackup": {
            "Type": "Task",
            "Resource": "arn:aws:states:::lambda:invoke",
            "InputPath": "$",
            "OutputPath": "$.Payload",
            "Parameters": {
              "Payload.$": "$",
              "FunctionName": "${aws_lambda_function.backup_executor_lambda.arn}"
            },
              "Next": "CheckIfCompleted"
          },
          "Succeed": {
            "Type": "Pass",
            "End": true
          }
        }
      },
      "Label": "Map",
      "End": true,
      "ResultWriter": {
        "Resource": "arn:aws:states:::s3:putObject",
        "Parameters": {
          "Bucket": "${aws_s3_bucket.backup_storage.id}",
          "Prefix": "BackupProcessJobs"
        }
      }
    }
  }
}
EOF

}

resource "aws_sfn_state_machine" "this" {

  name = "${var.vertical}-${var.environment}-cognito-backup-sfn"

  role_arn   = var.use_existing_role ? var.role_arn : aws_iam_role.backup_sfn[0].arn
  definition = local.definition

  dynamic "logging_configuration" {
    for_each = local.enable_logging ? [true] : []

    content {
      log_destination        = lookup(var.logging_configuration, "log_destination", "${local.log_group_arn}:*")
      include_execution_data = lookup(var.logging_configuration, "include_execution_data", null)
      level                  = lookup(var.logging_configuration, "level", null)
    }
  }

  dynamic "tracing_configuration" {
    for_each = local.enable_xray_tracing ? [true] : []
    content {
      enabled = true
    }
  }

  type = upper(var.type)

}

##################
# CloudWatch Logs
##################

data "aws_cloudwatch_log_group" "sfn" {
  count = local.enable_logging && var.use_existing_cloudwatch_log_group ? 1 : 0

  name = var.cloudwatch_log_group_name
}

resource "aws_cloudwatch_log_group" "sfn" {
  count = local.enable_logging && !var.use_existing_cloudwatch_log_group ? 1 : 0

  name              = coalesce(var.cloudwatch_log_group_name, "/aws/sfn/cognito-backup")
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = merge(var.tags, var.cloudwatch_log_group_tags)
}