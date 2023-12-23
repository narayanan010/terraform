terraform {
  backend "s3" {
    bucket  = "capterra-terraform-state-314485990717"
    key     = "s3/import-bucket/us-east-1/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    #dynamodb_table = "capterra-terraform-lock-table" 
  }
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
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::314485990717:role/assume-capterra-orange-staging-admin-nonmfa"
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
