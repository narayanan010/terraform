terraform {
  backend "s3" {}

  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = ">= 4.53.0"
      }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region  = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}