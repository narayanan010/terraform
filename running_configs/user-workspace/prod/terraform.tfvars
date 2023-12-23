
post_confirmation_lambda_arn      = "arn:aws:lambda:us-east-1:296947561675:function:user-workspace-prod-userPostConfirmation"
post_authentication_lambda_arn    = "arn:aws:lambda:us-east-1:296947561675:function:user-workspace-prod-userPostAuthentication"
pre_sign_up_lambda_arn            = "arn:aws:lambda:us-east-1:296947561675:function:user-workspace-prod-userPreSignup"
uw_acm_certificate_arn            = "arn:aws:acm:us-east-1:296947561675:certificate/ee9a8dbc-f352-4ac9-bff0-90cde7db903b"
pool_type                         = "oauth"
user_workspace_custom_domain_name = "workspaceauth.capterra.com"
google_client_id                  = "756105029491-4srter7fhs9oid4simsca24kcnindk37.apps.googleusercontent.com"
google_client_secret              = "wP6d8SlVCzRVh5lGZHVbIXiK"
uw_ses_arn                        = "arn:aws:ses:us-east-1:296947561675:identity/software@capterra.com"
uw_callback_urls                  = ["https://www.capterra.com/workspace/oauth2/idpresponse"]
uw_google_signout_urls            = ["https://www.capterra.com/workspace/", "https://www.capterra.com/"]
uw_client_signout_urls            = ["https://www.capterra.com/workspace/"]


# AWS infrastructure details
region            = "us-east-1"
monitoring        = true
terraform_managed = true

# Deploymen tag definition
application   = "userworkspace"
technology    = "userworkspace"
vertical      = "capterra"
stage         = "prd"
platform      = "data"
product       = "capterra"
environment   = "PRODUCTION"
function      = "cache"
business_unit = "dm"
app_contacts  = "capterradevops@gartner.com"
created_by    = "colin.taras@gartner.com/dan.oliva@gartner.com"
