# Deploy
modulecaller_source_region                = "us-east-1"
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Tags
application         = "eks-alarm"
app_component       = "alarm"
function            = "integration"
business_unit       = "gdm"
app_environment     = "prod"
app_contacts        = "opsteam@capterra.com"
created_by          = "fabio.perrone@gartner.com"
system_risk_class   = "3"
region              = "us-east-1"
network_environment = "prod"
monitoring          = "false"
terraform_managed   = true
vertical            = "capterra"
product             = "prisma"
environment         = "prod"

# SQS
message_retention_seconds = 1209600
sqs_managed_sse_enabled   = true