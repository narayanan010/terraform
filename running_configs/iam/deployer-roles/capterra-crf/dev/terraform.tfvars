# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::377773991577:role/capterra-admin-role"

# Deploymen tag definition
application   = "iam"
vertical      = "capterra"
product       = "capterra"
environment   = "dev"
app_contacts  = "capterra-devops"
function      = "deployment"
business_unit = "cap-bu"
created_by    = "fabio.perrone@gartner.com"