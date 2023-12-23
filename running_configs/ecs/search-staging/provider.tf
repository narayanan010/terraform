provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }

  default_tags {
    tags = module.tags_resource_module.tags
  }

  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update", "runner_info", "git_url", "git_path", "iac_platform"]
  }
}

provider "aws" {
  alias  = "route53_account"
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_dns_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update", "runner_info", "git_url", "git_path", "iac_platform"]
  }
}


provider "aws" {
  alias  = "buckets"
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
}

module "tags_resource_module" {
  source              = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"
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
