# AWS infrastructure details
region                                    = "us-east-1"
region_dr                                 = "us-west-2"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::296947561675:role/assume-capterra-search-prod-deployer"

# Deployment tag definition
application   = "clicks-streaming"
vertical      = "capterra"
product       = "oidc"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "fabio.perrone@gartner.com"
