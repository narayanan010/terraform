terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}


provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::944864126557:role/no-color-staging-admin"
  }
  default_tags {
    tags = {
      iac_platform = "terraform"
    }
  }
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = "us-east-1"
}
