provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.iam_deployer_role_arn
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}
