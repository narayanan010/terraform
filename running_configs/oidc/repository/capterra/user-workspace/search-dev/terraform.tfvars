# AWS infrastructure details
region                                   = "us-east-1"
monitoring                               = true
terraform_managed                        = true
modulecaller_assume_role_primary_account = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"

# Deploymen tag definition
application   = "user-workspace"
vertical      = "capterra"
product       = "oidc"
environment   = "dev"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"
