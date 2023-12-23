
  post_confirmation_lambda_arn = "arn:aws:lambda:us-east-1:148797279579:function:user-workspace-ci-userPostConfirmation"
  post_authentication_lambda_arn = "arn:aws:lambda:us-east-1:148797279579:function:user-workspace-ci-userPostAuthentication"
  uw_acm_certificate_arn = "arn:aws:acm:us-east-1:148797279579:certificate/640dc900-f568-423f-8e4f-939651d42969"
  stage = "dev-ci"
  environment = "DEV"
  pool_type  = "oauth"
  user_workspace_custom_domain_name = "wauth-dev-ci-ga.capstage.net"
  google_client_id = "756105029491-67ll831sc6uthqm9sfpkfmceqno5397k.apps.googleusercontent.com"
  google_client_secret = "MFmBQy2yeBG0OaG3gitLn-3m"
  uw_ses_arn = "arn:aws:ses:us-east-1:148797279579:identity/software@capterra.com"
  uw_callback_urls = ["https://www.capstage.net/workspace/oauth2/idpresponse"]
  uw_signout_urls =   ["https://www.capstage.net/workspace/"]
