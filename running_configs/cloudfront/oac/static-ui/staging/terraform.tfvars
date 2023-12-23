# AWS infrastructure details
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"

#OAC Definition
name        = "capterra-static-ui"
environment = "staging"

# Deploymen tag definition
tag_application         = "static-ui"
tag_app_component       = "capterra"
tag_function            = "cache-cdn"
tag_business_unit       = "gdm"
tag_app_environment     = "staging"
tag_app_contacts        = "capterra_devops"
tag_created_by          = "dan.oliva@gartner.com"
tag_system_risk_class   = 3
tag_region              = "us-east-1"
tag_network_environment = "staging"
tag_monitoring          = "false"
tag_terraform_managed   = "true"
tag_vertical            = "capterra"
tag_product             = "static-ui"
tag_environment         = "staging"
