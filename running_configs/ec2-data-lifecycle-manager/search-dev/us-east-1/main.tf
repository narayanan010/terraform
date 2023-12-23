module "aws_dlm_module" {
  source = "../../../../modules/ec2-data-lifecycle-manager"
  
  vertical                                  = var.vertical
  prod_backup_enabled                       = false
  staging_backup_enabled                    = false
  dev_backup_enabled                        = true
}

module "tags_resource_module" {
  source                  = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application             = "backup"
  app_component           = "dlm"
  app_environment         = "dev"
  function                = "automation"
  business_unit           = "gdm"
  app_contacts            = "capterra_devops"
  created_by              = "fabio.perrone@gartner.com"
  system_risk_class       = "3"
  region                  = var.modulecaller_source_region
  monitoring              = "false"
  terraform_managed       = "true"
  vertical                = var.vertical
  network_environment     = "dev"
  environment             = "dev"
  product                 = "dlm"


  tags = {
    "repository"          = "https://github.com/capterra/terraform.git"
  } 
}