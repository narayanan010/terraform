module "cognito-ga-main" {
  source         = "../cognito-main"
  user_pool_name = "ga-user-workspace-${var.stage}"
  email_message = {
    app = "GetApp"
  }
  post_confirmation_lambda_arn = var.post_confirmation_lambda_arn
  pre_signup_lambda_arn        = var.pre_signup_lambda_arn
  uw_ses_arn                   = var.uw_ses_arn
  user_pool_tags = {
    vertical = "getapp"
  }

  user_pool_client_name = "uw-staging-ga-client"
  identity_pool_name    = "uw-id-pool-staging-ga"
}
