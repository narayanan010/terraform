data "aws_caller_identity" "current" {}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.5"
  assume_role {
    role_arn = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"

  }
}