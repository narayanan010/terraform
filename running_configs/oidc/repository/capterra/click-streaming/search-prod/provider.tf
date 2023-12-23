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
    keys         = ["CreatorAutoTag", "CreatorId", "iac_platform", "last_update","git_path","git_url","runner_info"]
  }
}


provider "aws" {
  region = var.region_dr
  alias  = "region_dr"
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
}

