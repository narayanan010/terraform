# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
thumbprints                               = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]

# Deploymen tag definition
application   = "oidc"
vertical      = "capterra"
product       = "capterra"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"