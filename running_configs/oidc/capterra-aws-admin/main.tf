data "aws_caller_identity" "current" {}
provider "aws" {
  region = var.region
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "iac_platform", "last_update"]
  }
}

module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = var.application
  app_component       = "oidc"
  function            = var.function
  business_unit       = var.business_unit
  app_environment     = var.environment
  app_contacts        = var.app_contacts
  created_by          = var.created_by
  system_risk_class   = "1"
  region              = var.region
  network_environment = var.environment
  monitoring          = var.monitoring
  terraform_managed   = var.terraform_managed
  vertical            = var.vertical
  product             = var.product
  environment         = var.environment
}
