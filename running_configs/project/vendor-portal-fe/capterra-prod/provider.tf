provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
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
  region = var.modulecaller_source_region
  alias  = "untagged"
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
}
