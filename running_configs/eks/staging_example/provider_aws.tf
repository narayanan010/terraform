# data "aws_caller_identity" "landing" {
#   provider = aws.landing-account
# }

data "aws_caller_identity" "main" {}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.iam_deployer_role_arn
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "iac_platform", "last_update"]
  }
}