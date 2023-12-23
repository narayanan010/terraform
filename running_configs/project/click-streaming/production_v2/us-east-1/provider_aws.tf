provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update", "iac_platform"]
  }
}

# provider "aws" {
#   alias  = "capterra-aws-admin"
#   region = var.region
# }