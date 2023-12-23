provider "aws" {
  alias  = "primary_cf_account"
  region = var.modulecaller_source_region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
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
    #Below Role is R53 account Role. This can be replaced in variables with any assume Role info. I used assume role from Capterra
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
