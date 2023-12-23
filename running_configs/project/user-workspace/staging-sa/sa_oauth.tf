module "cognito-sa-oauth" {
  source         = "../cognito-oauth"
  user_pool_name = "sa-user-workspace-${var.stage}-${var.pool_type}"
  email_message = {
    app = "Software Advice"
  }

  post_confirmation_lambda_arn   = var.post_confirmation_lambda_arn
  post_authentication_lambda_arn = var.post_authentication_lambda_arn
  uw_ses_arn                     = var.uw_ses_arn

  user_pool_tags = {
    vertical = "Software Advice"
  }

  user_pool_client_name = "sa-userworkspace-oauth-client-${var.stage}"

  user_pool_client = {
    logout_urls   = var.uw_signout_urls
    callback_urls = var.uw_callback_urls
  }

  user_pool_domain = {
    domain          = var.user_workspace_custom_domain_name_sa
    certificate_arn = var.certificate_arn_sa
  }

  identity_provider = {
    client_id     = var.google_client_id_sa
    client_secret = var.google_client_secret_sa
  }
}
