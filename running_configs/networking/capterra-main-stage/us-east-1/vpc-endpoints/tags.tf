module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = "vpc_endpoint"
  app_component     = "network"
  function          = "vpc_endpoint"
  business_unit     = "gdm"
  app_contacts      = "capterra_devops"
  created_by        = "fabio.perrone@gartner.com"
  system_risk_class = "3"
  region            = var.modulecaller_source_region
  monitoring        = "false"
  terraform_managed = "true"
  vertical          = var.vertical
  environment       = "staging" 
  app_environment   = "staging" 
  network_environment = "staging"
  product           = "gdm"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}