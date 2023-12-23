provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}

module "tags_resource_module" {
  source = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = "cloudwatch-log-group-expiration"
  app_component       = "cloudwatch"
  function            = "retention"
  business_unit       = "gdm"
  app_environment     = "capterra-search-staging"
  app_contacts        = "capterra_devops"
  created_by          = "sarvesh.gupta@gartner.com"
  system_risk_class   = "3"
  region              = var.modulecaller_source_region
  network_environment = "capterra-search-staging"
  monitoring          = "true"
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "cloudwatch-log-group-expiration"
  environment         = "capterra-search-staging"
}
