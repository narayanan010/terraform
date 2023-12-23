terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.55.0"
        configuration_aliases = [ aws.authorized_account ]
      }
  }
  required_version = ">= 1.2"
}

provider "aws" {
 	alias      = "authorized_account"
  region     = var.modulecaller_source_region
  assume_role {
    #Below Role is Authorized account Role. This can be replaced in variables with any assume Role info. This is the account who's VPCs are to be authorized.
    role_arn = var.modulecaller_assume_role_authorized_account
  }
  default_tags {
    tags     = module.tags_resource_module.tags
  }
 }

provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    role_arn  = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}