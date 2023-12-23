data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}


provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::738909422062:role/assume-crf-production-admin"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}

module "tags_resource_module" {
  source = "git::https://github.com/capterra/terraform.git//modules/tagging-resource-module"
  
  application         = var.application
  app_component       = "sg"
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