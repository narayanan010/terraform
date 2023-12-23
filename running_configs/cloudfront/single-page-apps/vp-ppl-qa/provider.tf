terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
	alias = "search_staging_assume"
	version = "~>v2.55.0"
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  }
}

provider "aws" {
 	region = "us-east-1"
}