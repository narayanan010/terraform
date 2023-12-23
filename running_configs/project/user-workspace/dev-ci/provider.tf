terraform {
    backend "s3" {}

}

data "aws_caller_identity" "current" {}

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"
  }
}

provider "aws" {
    region = "us-east-1"
    alias = "capterra"
    assume_role {
      role_arn     = "arn:aws:iam::176540105868:role/assume-capterra-admin"
  }
}