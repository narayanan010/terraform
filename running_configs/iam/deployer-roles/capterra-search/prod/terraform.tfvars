# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"

# Deploymen tag definition
application   = "iam"
vertical      = "capterra"
product       = "capterra"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "deployment"
business_unit = "cap-bu"
created_by    = "fabio.perrone@gartner.com"