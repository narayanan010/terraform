data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {}
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.67.0"
        configuration_aliases = [ aws.primary ]
      }
  }
}

provider "aws" {
  alias   = "primary"
  region  = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
}