# AWS infrastructure details
region                                    = "us-east-1"
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::350125959894:role/gdm-admin-access"

# Deploymen tag definition
application   = "cognito"
vertical      = "capterra"
product       = "capterra"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "backup"
business_unit = "cap-bu"
created_by    = "fabio.perrone@gartner.com"
monitoring    = true