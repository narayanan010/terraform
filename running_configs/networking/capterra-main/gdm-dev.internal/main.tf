module "dns-zones" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/route-53/zones"
  zones = {
    "gdmdev_internal" = {
      domain_name         = "gdm-dev.internal"
      comment             = "${var.vpc_id} - association for private DNS for gdm-dev internal"
      delegation_set_id   = null
      vpc                 = {
        "main-dev" = {
          id                  = var.vpc_id
          region              = var.modulecaller_source_region
        }
      }
      force_destroy       = false
    }
  }
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = "r53"
  app_component       = "network"
  function            = "internal"
  business_unit       = "gdm"
  app_contacts        = "capterra_devops"
  created_by          = "narayanan.narasimhan@gartner.com"
  system_risk_class   = "3"
  region              = var.modulecaller_source_region
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = var.vertical
  environment         = "dev" 
  app_environment     = "dev" 
  network_environment = "dev"
  product             = "gdm"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}