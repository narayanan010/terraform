# Deploy
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"
modulecaller_assume_role_ecs_deployer     = "arn:aws:iam::148797279579:role/github-actions-user-workspace-dev"
modulecaller_assume_role_dns_account      = "arn:aws:iam::176540105868:role/assume-capterra-power-user"


# Tags
tag_application         = "bx-ba-api"
tag_app_component       = "ecs"
tag_function            = "api"
tag_business_unit       = "gdm"
tag_app_environment     = "dev"
tag_app_contacts        = "capterra-devops"
tag_created_by          = "dan.oliva@gartner.com"
tag_system_risk_class   = "2"
tag_region              = "us-east-1"
tag_network_environment = "dev"
tag_monitoring          = true
tag_terraform_managed   = true
tag_vertical            = "cap"
tag_product             = "dev"
tag_environment         = "dev"

# VPC details
vpc_id = "vpc-0b340ad818cf0648b"

# CloudWatch details
cw_logs_retention = 1

# Route53
modulecaller_dns_r53_hostedzone = "capstage.net"

# Kinesis
datadog_http_endpoint = "https://aws-kinesis-http-intake.logs.datadoghq.com/v1/input"