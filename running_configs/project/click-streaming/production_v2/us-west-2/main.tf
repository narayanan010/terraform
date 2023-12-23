module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module?ref=module_tags_tfv0.12"

  application         = var.application
  app_component       = var.app_component
  function            = var.function
  business_unit       = var.business_unit
  app_environment     = var.environment
  app_contacts        = var.app_contacts
  created_by          = var.created_by
  system_risk_class   = var.system_risk_class
  region              = var.region
  network_environment = var.environment
  monitoring          = var.monitoring
  terraform_managed   = var.terraform_managed
  vertical            = var.vertical
  product             = var.product
  environment         = var.environment
}
