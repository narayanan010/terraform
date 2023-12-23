data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}


provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
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
