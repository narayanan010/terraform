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
    keys         = ["CreatorAutoTag", "CreatorId", "iac_platform", "last_update"]
  }
}

provider "aws" {
  alias  = "dr_region"
  region = var.modulecaller_source_dr_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }

  default_tags {
    tags = module.tags_dr_resource_module.tags
  }
}