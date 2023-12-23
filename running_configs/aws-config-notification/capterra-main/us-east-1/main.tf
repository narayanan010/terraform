module "aws-config-notification" {
  source                           = "../../../../modules/aws-config-notification"
  region_aws                       = "us-east-1"
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
