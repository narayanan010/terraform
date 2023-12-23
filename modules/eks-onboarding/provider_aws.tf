data "aws_caller_identity" "landing" {
  provider = aws.landing-account
}

data "aws_caller_identity" "main" {}
data "aws_region" "main" {}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.iam_deployer_role
  }
  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  alias  = "landing-account"
  region = var.region_landing
  default_tags {
    tags = var.tags
  }
}