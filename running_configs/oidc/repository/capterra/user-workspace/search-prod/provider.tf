data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId"]
  }
}
