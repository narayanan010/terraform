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


provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  }
  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = "us-west-2"
}
