# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer"

# Deploymen tag definition
application   = "clicks-streaming"
vertical      = "capterra"
product       = "oidc"
environment   = "staging"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "fabio.perrone@gartner.com"
