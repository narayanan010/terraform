terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
  alias  = "primary_cf_account"
  region = var.region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
    role_arn = "arn:aws:iam::296947561675:role/assume-capterra-search-prod-deployer"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  
  ignore_tags {
    key_prefixes = ["tags","tags_all"]
    keys = ["CreatorAutoTag","CreatorId","last_update"]
  }
}

provider "aws" {
  alias  = "route53_account"
  region = var.region
  assume_role {
    #Below Role is R53 account Role. This can be replaced in variables with any assume Role info. I used assume role from Capterra
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  
  ignore_tags {
    key_prefixes = ["tags","tags_all"]
    keys = ["CreatorAutoTag","CreatorId","last_update"]
  }
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = var.region
}

#Added this to fix "argument region not set error" while running plan. Bug in Provider.
provider "aws" {
  region = var.region
}

module "tags_resource_module" {
  source              = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"
  application         = var.tag_application
  app_component       = var.tag_app_component
  function            = var.tag_function
  business_unit       = var.tag_business_unit
  app_environment     = var.tag_app_environment
  app_contacts        = var.tag_app_contacts
  created_by          = var.tag_created_by
  system_risk_class   = var.tag_system_risk_class
  region              = var.tag_region
  network_environment = var.tag_network_environment
  monitoring          = var.tag_monitoring
  terraform_managed   = var.tag_terraform_managed
  vertical            = var.tag_vertical
  product             = var.tag_product
  environment         = var.tag_environment
}