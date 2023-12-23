#data "aws_caller_identity" "current" {}
provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }

  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update", "iac_platform"]
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "main-resources"
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "iac_platform", "last_update"]
  }
}