module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = var.application
  app_component       = "k8s"
  function            = "service-account-iam"
  business_unit       = "gdm"
  app_contacts        = "capterra_devops"
  created_by          = "fabio.perrone@gartner.com"
  system_risk_class   = "3"
  region              = var.modulecaller_source_region
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = var.vertical
  environment         = var.environment
  app_environment     = var.environment
  network_environment = var.environment
  product             = var.application

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}
