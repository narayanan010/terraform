# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::738909422062:role/assume-crf-production-admin"
thumbprints                               = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]

# Deploymen tag definition
application       = "oidc"
app_component     = "crf"
function          = "federation"
business_unit     = "crf"
app_contacts      = "capterra_devops"
created_by        = "narayanan.narasimhan@gartner.com"
vertical          = "crf"
product           = "oidc"
environment       = "prod"
system_risk_class = 1
