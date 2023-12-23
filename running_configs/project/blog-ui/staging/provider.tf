data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.55.0"
        configuration_aliases = [ aws.awscaller_account ]
      }
      #required_version = ">= 1.2"
  }
}

provider "aws" {
  alias   = "awscaller_account"
  region  = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }

  default_tags {
    tags = module.tags_resource_module.tags
  }
} 

