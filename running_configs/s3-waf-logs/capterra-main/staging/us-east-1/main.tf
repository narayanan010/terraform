module "s3_waf_logs" {
  source       = "../../../../../modules/s3-waf-logs"
  region       = var.modulecaller_source_region
  stage        = var.stage
  account_name = var.account_name
  vertical     = var.vertical
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = var.application
  app_component     = var.app_component
  function          = var.function
  business_unit     = var.business_unit
  app_contacts      = var.app_contacts
  created_by        = var.created_by
  system_risk_class = var.system_risk_class
  region            = var.modulecaller_source_region
  monitoring        = "false"
  terraform_managed = "true"
  vertical          = var.vertical

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}
