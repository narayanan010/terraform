data "aws_caller_identity" "current" {}
terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source                = "hashicorp/aws"
        version               = ">= 4.40.0"
        configuration_aliases = [ aws.aws_sot_account, aws.awscaller_account ]
      }
  }
}

provider "aws" {
	alias      = "aws_sot_account"
  region     = var.modulecaller_source_region
  assume_role {
    #Below Role is SOT (SOURCE OF TRUTH for AZ-ID) account Role. This can be replaced in variables with any assume Role info. This is from account where everything is to be deployed. It is Capterra-Main Account
    role_arn = var.modulecaller_assume_role_sot_account
  }
  default_tags {
    tags     = module.tags_resource_module.tags
  }
 }

provider "aws" {
 	alias      = "awscaller_account"
  region     = var.modulecaller_source_region
  assume_role {
    #Below Role is Deployer account Role. This can be replaced in variables with any assume Role info. This is from account where everything is to be deployed
    role_arn = var.modulecaller_assume_role_deployer_account
  }
  default_tags {
    tags     = module.tags_resource_module.tags
  }
 }

#Added this to fix "argument region not set error" while running plan. Bug in Provider.
provider "aws" {
  region     = var.modulecaller_source_region
  default_tags {
    tags     = module.tags_resource_module.tags
  }
}

module "tags_resource_module" {
  source                      = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"
  application                 = var.tag_application
  app_component               = var.tag_app_component
  function                    = var.tag_function
  business_unit               = var.tag_business_unit
  app_environment             = var.tag_app_environment
  app_contacts                = var.tag_app_contacts
  created_by                  = var.tag_created_by
  system_risk_class           = var.tag_system_risk_class
  region                      = var.tag_region
  network_environment         = var.tag_network_environment
  monitoring                  = var.tag_monitoring
  terraform_managed           = var.tag_terraform_managed
  vertical                    = var.tag_vertical
  product                     = var.tag_product
  environment                 = var.tag_environment
}