terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}
