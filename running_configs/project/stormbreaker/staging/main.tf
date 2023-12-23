data "aws_caller_identity" "current" {}

module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = var.application
  app_component       = "gdm"
  function            = "cache-cdn"
  business_unit       = "gdm"
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "dan.oliva@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "staging"
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = "gdm"
  product             = var.application
  environment         = "staging"
}
