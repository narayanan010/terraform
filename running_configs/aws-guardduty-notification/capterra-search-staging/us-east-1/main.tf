module "aws-guardduty-notification" {
  source     = "../../../../modules/aws-guardduty-notification"
  region_aws = var.modulecaller_source_region
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = "guardduty"
  app_component     = "guardduty"
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
