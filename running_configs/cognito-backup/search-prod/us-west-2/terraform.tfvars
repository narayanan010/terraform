# AWS infrastructure details
region                                    = "us-west-2"
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"

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