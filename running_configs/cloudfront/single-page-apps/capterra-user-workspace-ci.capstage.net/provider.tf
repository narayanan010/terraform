provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-developer"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}


module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = "user-workspace"
  app_component       = "capterra"
  function            = "cache-cdn"
  business_unit       = "gdm"
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "dan.oliva@gartner.com/alexandervalkov@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "dev"
  monitoring          = "true"
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "user-workspace"
  environment         = "dev"
}
