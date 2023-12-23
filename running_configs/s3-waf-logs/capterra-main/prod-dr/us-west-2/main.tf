module "s3_waf_logs" {
  source       = "../../../../../modules/s3-waf-logs/"
  region       = var.modulecaller_source_region
  stage        = var.stage
  account_name = var.account_name
  vertical     = var.vertical
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"
  application         = var.tag_application
  app_component       = var.tag_app_component
  function            = var.tag_function
  business_unit       = var.tag_business_unit
  app_environment     = var.tag_environment
  app_contacts        = var.tag_app_contacts
  created_by          = var.tag_created_by
  system_risk_class   = var.tag_system_risk_class
  region              = var.tag_region
  network_environment = var.tag_environment
  monitoring          = var.tag_monitoring
  terraform_managed   = var.tag_terraform_managed
  vertical            = var.tag_vertical
  product             = var.tag_product
  environment         = var.tag_environment

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}        

  # application       = var.application
  # app_component     = var.app_component
  # function          = var.function
  # business_unit     = var.business_unit
  # app_contacts      = var.app_contacts
  # created_by        = var.created_by
  # system_risk_class = var.system_risk_class
  # region            = var.modulecaller_source_region
  # monitoring        = "false"
  # terraform_managed = "true"
  # vertical          = var.vertical