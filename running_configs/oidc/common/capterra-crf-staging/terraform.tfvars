# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::350125959894:role/gdm-dev-full_role"
thumbprints                               = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]

# Deploymen tag definition
application       = "oidc"
app_component     = "gdm-ui"
function          = "federation"
business_unit     = "gdm-ui"
app_contacts      = "capterra_devops"
created_by        = "narayanan.narasimhan@gartner.com"
vertical          = "gdm-ui"
product           = "oidc"
environment       = "staging"
system_risk_class = 1
