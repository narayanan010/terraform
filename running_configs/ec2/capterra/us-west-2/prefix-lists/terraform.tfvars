# Deploy
modulecaller_source_region                = "us-west-2"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Tags
tag_application         = "security"
tag_app_component       = "ec2"
tag_function            = "security"
tag_business_unit       = "gdm"
tag_app_environment     = "dev"
tag_app_contacts        = "opsteam@capterra.com"
tag_created_by          = "daniel.lopezlopez@gartner.com"
tag_system_risk_class   = "3"
tag_region              = "us-west-2"
tag_network_environment = "dev"
tag_monitoring          = "false"
tag_terraform_managed   = true
tag_vertical            = "capterra"
tag_product             = "security"
tag_environment         = "dev"

repository_name      = "terraform"
image_tag_mutability = "MUTABLE"
force_delete         = false
encryption_type      = "AES256"