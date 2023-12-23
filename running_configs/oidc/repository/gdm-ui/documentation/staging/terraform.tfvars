# AWS infrastructure details
region                                     = "us-east-1"
monitoring                                 = true
terraform_managed                          = true
modulecaller_assume_role_deployer_account  = "arn:aws:iam::350125959894:role/gdm-dev-full_role"
aws_iam_openid_connect_provider_github_arn = "arn:aws:iam::350125959894:oidc-provider/token.actions.githubusercontent.com"

# Deploymen tag definition
application       = "documentation"
vertical          = "gdm-ui"
product           = "documentation"
environment       = "staging"
app_contacts      = "capterra_devops"
function          = "federation"
business_unit     = "gdm-ui"
created_by        = "dan.oliva@gartner.com"
app_component     = "gdm-ui"
system_risk_class = 3
