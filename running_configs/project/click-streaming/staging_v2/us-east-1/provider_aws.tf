data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }

  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update", "iac_platform"]
  }
}
