# Deploy
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Route53
modulecaller_dns_r53_hostedzone = "capstage.net"

# Tags
tag_application         = "vendor-portal-fe"
tag_app_component       = "k8s"
tag_function            = "k8s_ingress"
tag_business_unit       = "gdm"
tag_app_environment     = "staging"
tag_app_contacts        = "@devops-ce-emea-team"
tag_created_by          = "dan.oliva@gartner.com"
tag_system_risk_class   = "2"
tag_region              = "us-east-1"
tag_network_environment = "staging"
tag_monitoring          = true
tag_terraform_managed   = true
tag_vertical            = "cap"
tag_product             = "vendor-portal-fe"
tag_environment         = "staging"


