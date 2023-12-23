module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = var.application
  app_component       = var.app_component
  function            = var.function
  business_unit       = var.business_unit
  app_contacts        = var.app_contacts
  created_by          = var.created_by
  system_risk_class   = var.system_risk_class
  region              = var.modulecaller_source_region
  monitoring          = var.monitoring
  terraform_managed   = "true"
  vertical            = var.vertical
  environment         = var.environment
  app_environment     = var.environment
  network_environment = var.environment
  product             = var.application

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}
