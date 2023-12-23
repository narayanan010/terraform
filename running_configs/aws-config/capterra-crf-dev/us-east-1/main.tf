module "aws-config" {
  source                           = "../../../../modules/aws-config"
  region_aws                       = "us-east-1"
  is_config_managed_by_ccoe        = false
  is_config_bucket_managed_by_ccoe = true
  is_forwarding_to_slack_enabled   = true
  destination_event_bus_arn        = data.terraform_remote_state.aws_config_notification.outputs.config_notification_eventbridge_bus_arn
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = "config"
  app_component     = "config"
  function          = "security"
  business_unit     = "gdm"
  app_contacts      = "capterra_devops"
  created_by        = "fabio.perrone@gartner.com"
  system_risk_class = "3"
  region            = var.modulecaller_source_region
  monitoring        = "false"
  terraform_managed = "true"
  vertical          = var.vertical

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}

data "terraform_remote_state" "aws_config_notification" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "aws-config-notification/capterra-main/us-east-1/terraform.tfstate"
  }
}
