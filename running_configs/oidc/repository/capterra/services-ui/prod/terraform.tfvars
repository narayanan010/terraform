# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"

# Deploymen tag definition
application   = "services-ui"
vertical      = "capterra"
product       = "oidc"
environment   = "production" # Not change to 'prod'. Multiple dependencies
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"