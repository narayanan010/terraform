module "route-53-backup" {
  source       = "../../../../modules/networking/route-53-backup/"
  interval     = var.interval 
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"
  #source = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"  
  application         = var.application
  app_component       = var.app_component
  function            = var.function
  business_unit       = var.business_unit
  app_contacts        = var.app_contacts
  created_by          = var.created_by
  system_risk_class   = var.system_risk_class
  region              = var.modulecaller_source_region
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = var.vertical
  network_environment = var.network_environment
  product             = var.product
  app_environment     = var.app_environment
  environment         = var.environment  
  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}
