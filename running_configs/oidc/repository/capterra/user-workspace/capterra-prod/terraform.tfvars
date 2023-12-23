# AWS infrastructure details
region                                     = "us-east-1"
monitoring                                 = true
terraform_managed                          = true
modulecaller_assume_role_deployer_account  = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
aws_iam_openid_connect_provider_github_arn = "arn:aws:iam::176540105868:oidc-provider/token.actions.githubusercontent.com"

# Deploymen tag definition
application   = "user-workspace"
vertical      = "capterra"
product       = "oidc"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"