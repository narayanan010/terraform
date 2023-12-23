# AWS infrastructure details
region                                     = "us-east-1"
monitoring                                 = true
terraform_managed                          = true
modulecaller_assume_role_deployer_account  = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
aws_iam_openid_connect_provider_github_arn = "arn:aws:iam::273213456764:oidc-provider/token.actions.githubusercontent.com"

# Deploymen tag definition
application   = "static-ui"
vertical      = "capterra"
product       = "oidc"
environment   = "staging"
app_contacts  = "capterra-devops"
function      = "federation"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"