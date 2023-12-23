# Deploy
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Tags
tag_application         = "cap-es-uvp"
tag_app_component       = "ecr"
tag_function            = "image-storage"
tag_business_unit       = "gdm"
tag_app_environment     = "prod"
tag_app_contacts        = "opsteam@capterra.com"
tag_created_by          = "narayanan.narasimhan@gartner.com"
tag_system_risk_class   = "3"
tag_region              = "us-east-1"
tag_network_environment = "prod"
tag_monitoring          = "false"
tag_terraform_managed   = true
tag_vertical            = "capterra"
tag_product             = "cap-es-uvp"
tag_environment         = "prod"

# Custom Tags
github_repository_oidc_access = "cap-es-uvp"
team_sso_access               = "admin"

# Repository
repository_name      = "cap-es-uvp"
image_tag_mutability = "MUTABLE"
force_delete         = false
encryption_type      = "AES256"
