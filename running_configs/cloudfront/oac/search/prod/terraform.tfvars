# AWS infrastructure details
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"

#OAC Definition
name        = "capterra-search"
environment = "prod"

# Deploymen tag definition
tag_application         = "search"
tag_app_component       = "capterra"
tag_function            = "cache-cdn"
tag_business_unit       = "gdm"
tag_app_environment     = "prod"
tag_app_contacts        = "capterra_devops"
tag_created_by          = "narayanan.narasimhan@gartner.com"
tag_system_risk_class   = 3
tag_region              = "us-east-1"
tag_network_environment = "prod"
tag_monitoring          = "false"
tag_terraform_managed   = "true"
tag_vertical            = "capterra"
tag_product             = "search"
tag_environment         = "prod"
