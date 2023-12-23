module "prisma_alarm" {
  source = "../../../../modules/prisma/alarm-integration"

  vertical                  = var.vertical
  product                   = var.product
  app_component             = var.app_component
  environment               = var.environment
  message_retention_seconds = var.message_retention_seconds
  sqs_managed_sse_enabled   = var.sqs_managed_sse_enabled
}