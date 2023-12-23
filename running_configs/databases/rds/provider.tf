data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.67.0"
      configuration_aliases = [aws.primary, aws.secondary]
    }
  }
  required_version = ">= 1.5.4"
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"
  assume_role {
    role_arn = var.deploy_account_role
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
  assume_role {
    role_arn = var.deploy_account_role
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}

