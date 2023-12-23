module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = var.application
  app_component       = var.app_component
  function            = var.function
  business_unit       = var.business_unit
  app_environment     = var.app_environment
  app_contacts        = var.app_contacts
  created_by          = var.created_by
  system_risk_class   = var.system_risk_class
  region              = var.region
  network_environment = var.network_environment
  monitoring          = var.monitoring
  terraform_managed   = var.terraform_managed
  vertical            = var.vertical
  product             = var.product
  environment         = var.environment
}
