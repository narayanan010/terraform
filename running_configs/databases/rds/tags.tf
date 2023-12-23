
#*************************************************************************************************************************************************************#
#                                         MANDATORY TAGS MODULE PER GARTNER CCOE AND CAPTERRA BEST PRACTICES                                                  #
#*************************************************************************************************************************************************************#

module "tags_resource_module" {
  source              = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"
  application         = var.application
  app_component       = var.tag_app_component
  function            = var.tag_function
  business_unit       = var.tag_business_unit
  app_environment     = var.environment
  app_contacts        = var.tag_app_contacts
  created_by          = var.tag_created_by
  system_risk_class   = var.tag_system_risk_class
  network_environment = var.environment
  monitoring          = var.tag_monitoring
  terraform_managed   = var.tag_terraform_managed
  vertical            = var.tag_vertical
  product             = var.tag_product
  environment         = var.environment
  region              = var.tag_default_region
}