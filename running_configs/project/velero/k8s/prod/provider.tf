data "aws_caller_identity" "current" {}

provider "aws" {
  alias  = "main_account"
  region = var.region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }

  default_tags {
    tags = module.tags_resource_module.tags
  }
}