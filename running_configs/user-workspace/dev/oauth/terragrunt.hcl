include {
  path = find_in_parent_folders()
}

inputs = {
  post_confirmation_lambda_arn = "arn:aws:lambda:us-east-1:148797279579:function:user-workspace-leo-userPostConfirmation"
  post_authentication_lambda_arn = "arn:aws:lambda:us-east-1:148797279579:function:user-workspace-leo-userPostAuthentication"
  uw_acm_certificate_arn = "arn:aws:acm:us-east-1:148797279579:certificate/9a4ca666-6d8a-4953-a990-9147e10051d2"
  stage = "dev"
  environment = "DEVELOPMENT"
  pool_type  = "oauth"
  user_workspace_custom_domain_name = "workspaceauth-dev.capstage.net"
  google_client_id = "756105029491-j9qsfi9p3fkias2qhqabjj8oq0va0qbe.apps.googleusercontent.com"
  google_client_secret = "xAkfIvqkOgpCBy0ep4ZOTioq"
  uw_ses_arn = "arn:aws:ses:us-east-1:148797279579:identity/software@capterra.com"
  uw_callback_urls = ["http://localhost:8080/workspace/oauth2/idpresponse"]
  uw_signout_urls =   ["http://localhost:8080/workspace/"]
}