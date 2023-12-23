
post_confirmation_lambda_arn      = "arn:aws:lambda:us-east-1:273213456764:function:user-workspace-staging-userPostConfirmation"
post_authentication_lambda_arn    = "arn:aws:lambda:us-east-1:273213456764:function:user-workspace-staging-userPostAuthentication"
uw_acm_certificate_arn            = "arn:aws:acm:us-east-1:273213456764:certificate/076886f3-b5f1-417b-a9e3-0b017fb3ce20"
pool_type                         = "oauth"
user_workspace_custom_domain_name = "workspaceauth.capstage.net"
google_client_id                  = "756105029491-67ll831sc6uthqm9sfpkfmceqno5397k.apps.googleusercontent.com"
google_client_secret              = "MFmBQy2yeBG0OaG3gitLn-3m"
uw_ses_arn                        = "arn:aws:ses:us-east-1:273213456764:identity/software@capterra.com"
uw_callback_urls                  = ["https://www.capstage.net/workspace/oauth2/idpresponse"]
#uw_signout_urls                   = ["https://www.capstage.net/workspace/"]
uw_signout_urls = ["https://www.capstage.net/workspace/", "https://www.capstage.net/"]

# AWS infrastructure details
region            = "us-east-1"
monitoring        = true
terraform_managed = true

# Deploymen tag definition
application   = "userworkspace"
technology    = "userworkspace"
vertical      = "capterra"
stage         = "stg"
platform      = "data"
product       = "capterra"
environment   = "STAGING"
function      = "cache"
business_unit = "dm"
app_contacts  = "capterradevops@gartner.com"
created_by    = "colin.taras@gartner.com/dan.oliva@gartner.com"
