terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10.0"
    }
  }
  required_version = "~> 1.5.1"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "iac_platform", "last_update"]
  }
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
}