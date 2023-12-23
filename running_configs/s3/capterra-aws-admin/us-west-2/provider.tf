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
  region = "us-west-2"
  default_tags {
    tags = {
      iac_platform = "terraform"
    }
  }
}
