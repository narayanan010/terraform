# AWS infrastructure details
region                                   = "us-east-1"
monitoring                               = true
terraform_managed                        = true
modulecaller_assume_role_primary_account = "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin"

# AWS infrastructure details
application   = "oidc"
app_component = "gdm"
function      = "federation"
business_unit = "gdm"
app_contacts  = "capterra_devops"
created_by    = "dan.oliva@gartner.com"
vertical      = "gdm"
product       = "common"
environment   = "development"
