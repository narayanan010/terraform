resource "aws_cloudwatch_event_rule" "backup" {
  name_prefix = "cognito-backup-"
  description = "Trigger Cognito backup automation"
  role_arn = aws_iam_role.eventbridge.arn
  schedule_expression = var.backup_schedule_expression
  is_enabled = var.is_trigger_enabled
}

resource "aws_cloudwatch_event_target" "sfn" {
  rule      = aws_cloudwatch_event_rule.backup.name
  target_id = "cognito-backup"
  arn       = aws_sfn_state_machine.this.arn
  role_arn  = aws_iam_role.eventbridge.arn
}