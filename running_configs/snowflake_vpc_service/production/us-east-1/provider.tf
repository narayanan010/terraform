terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}



provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::176540105868:role/assume-capterra-admin"
  }
}

provider "aws" {
  alias = "capterra-aws-admin"
  region = "us-east-1"
}