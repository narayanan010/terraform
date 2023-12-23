data "aws_caller_identity" "current" {}

locals {
  is_notification_account = data.aws_caller_identity.current.account_id == var.aws_notification_account ? true : false
}

locals {
    remote_destination_event_bus = local.is_notification_account ? "" : data.terraform_remote_state.aws_central_notification[0].outputs.guardduty_notification_eventbridge_bus_arn
}

data "terraform_remote_state" "aws_central_notification" {
  count = local.is_notification_account ? 0 : 1
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "aws-guardduty-notification/capterra-main/us-east-1/terraform.tfstate"
  }
}
