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


provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::377773991577:role/crf-dev-admin"
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
