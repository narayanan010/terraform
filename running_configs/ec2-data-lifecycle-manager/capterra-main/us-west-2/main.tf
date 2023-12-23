module "aws_dlm_module" {
  source = "../../../../modules/ec2-data-lifecycle-manager"
  
  vertical                = var.vertical
  prod_backup_enabled     = true
  staging_backup_enabled  = true
  dev_backup_enabled      = true
  dlm_lifecycle_role_arn  = "arn:aws:iam::176540105868:role/AWSDataLifecycleManagerCustomRoleForAMIManagement"
}

module "tags_resource_module" {
  source                  = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application             = "backup"
  app_component           = "dlm"
  function                = "automation"
  business_unit           = "gdm"
  app_contacts            = "capterra_devops"
  created_by              = "fabio.perrone@gartner.com"
  system_risk_class       = "3"
  region                  = var.modulecaller_source_region
  monitoring              = "false"
  terraform_managed       = "true"
  vertical                = var.vertical

  tags = {
    "repository"          = "https://github.com/capterra/terraform.git"
  } 
}