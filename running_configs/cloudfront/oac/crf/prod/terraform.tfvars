# AWS infrastructure details
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::738909422062:role/assume-crf-production-admin"

#OAC Definition
name        = "capterra-crf"
environment = "prod"

# Deploymen tag definition
tag_application         = "crf"
tag_app_component       = "capterra"
tag_function            = "cache-cdn"
tag_business_unit       = "gdm"
tag_app_environment     = "prod"
tag_app_contacts        = "capterra_devops"
tag_created_by          = "fabio.perrone@gartner.com"
tag_system_risk_class   = 3
tag_region              = "us-east-1"
tag_network_environment = "prod"
tag_monitoring          = "false"
tag_terraform_managed   = "true"
tag_vertical            = "capterra"
tag_product             = "capterra-crf"
tag_environment         = "prod"

