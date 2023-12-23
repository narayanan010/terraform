provider "aws" {
  region = var.modulecaller_source_region
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

provider "aws" {
  alias  = "route53_account"
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_dns_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId"]
  }
}

provider "aws" {
  alias  = "tagless_cf_account" # Used to remove tags from some resources
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }
}