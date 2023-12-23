terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::944864126557:role/no-color-staging-admin"
  }
  default_tags {
    tags = {
      iac_platform = "terraform"
      ENVIRONMENT  = var.envr
    }
  }
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = "us-east-1"
  default_tags {
    tags = {
      iac_platform = "terraform"
      ENVIRONMENT  = var.envr
    }
  }
}
