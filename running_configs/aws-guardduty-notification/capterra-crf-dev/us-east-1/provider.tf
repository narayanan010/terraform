data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
}

provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
    role_arn = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}
