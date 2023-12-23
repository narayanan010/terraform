# AWS infrastructure details
region                                     = "us-west-2"
monitoring                                 = true
terraform_managed                          = true
modulecaller_assume_role_deployer_account  = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
aws_iam_openid_connect_provider_github_arn = "arn:aws:iam::176540105868:oidc-provider/token.actions.githubusercontent.com"

# Deploymen tag definition
application         = "iam"
app_component       = "eks"
app_environment     = "eks"
function            = "eks_admin"
business_unit       = "capterra"
app_contacts        = "capterra_devops"
created_by          = "dan.oliva@gartner.com"
vertical            = "capterra"
product             = "identity"
network_environment = "prod-dr"
environment         = "prod-dr"
