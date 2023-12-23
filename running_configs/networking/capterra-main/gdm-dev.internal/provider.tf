terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.55.0"
      }
  }
  required_version = ">= 1.2"
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