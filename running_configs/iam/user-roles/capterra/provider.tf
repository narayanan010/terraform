terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.0"
    }
  }
  required_version = ">= 1.1.0"
}

data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "landing" {
  provider = aws.capterra-aws-admin
}


provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update"]
  }
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = "us-east-1"
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update"]
  }
}
