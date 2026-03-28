terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.38.0"
    }
  }
}

data "aws_caller_identity" "current" {}


provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::920909017907:role/nnpractice-admin-role"
  }
  default_tags {
    tags = {
      iac_platform = "terraform"
    }
  }
}
