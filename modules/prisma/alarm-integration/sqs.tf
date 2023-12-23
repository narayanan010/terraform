resource "aws_sqs_queue" "prisma_alarm_queue" {
  name                      = "${var.vertical}-${var.product}-${var.app_component}-${var.environment}"
  message_retention_seconds = var.message_retention_seconds
  sqs_managed_sse_enabled   = var.sqs_managed_sse_enabled
}
