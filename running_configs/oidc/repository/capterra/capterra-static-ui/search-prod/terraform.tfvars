# AWS infrastructure details
region                                     = "us-east-1"
monitoring                                 = true
terraform_managed                          = true
modulecaller_assume_role_deployer_account  = "arn:aws:iam::296947561675:role/assume-capterra-search-prod-deployer"
aws_iam_openid_connect_provider_github_arn = "arn:aws:iam::296947561675:oidc-provider/token.actions.githubusercontent.com"

# Deploymen tag definition
application   = "static-ui"
vertical      = "capterra"
product       = "oidc"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"
