data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"
  #version = "~> v2.55.0"
  version = "v2.55.0"
  assume_role {
    role_arn = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  }
  # default_tags {
  #   tags = module.tags_resource_module.tags
  # }
}

provider "aws" {
  region = "us-east-1"
  alias  = "capterra"
  assume_role {
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-admin"
  }
  # default_tags {
  #   tags = module.tags_resource_module.tags
  # }
}

# module "tags_resource_module" {
#   source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

#   application         = var.application
#   app_component       = var.application
#   function            = var.function
#   business_unit       = var.business_unit
#   app_environment     = var.environment
#   app_contacts        = var.app_contacts
#   created_by          = var.created_by
#   system_risk_class   = "1"
#   region              = var.region
#   network_environment = var.environment
#   monitoring          = var.monitoring
#   terraform_managed   = var.terraform_managed
#   vertical            = var.vertical
#   product             = var.product
#   environment         = var.environment
# }