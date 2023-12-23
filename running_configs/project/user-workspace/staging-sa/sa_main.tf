module "cognito-sa-main" {
  source         = "../cognito-main"
  user_pool_name = "sa-user-workspace-${var.stage}"
  email_message = {
    app = "Software Advice"
  }
  post_confirmation_lambda_arn = var.post_confirmation_lambda_arn
  pre_signup_lambda_arn        = var.pre_signup_lambda_arn
  uw_ses_arn                   = var.uw_ses_arn
  user_pool_tags = {
    vertical = "softwareadvice"
  }

  user_pool_client_name = "uw-stg-ci-sa-client"
  identity_pool_name    = "uw-id-pool-stg-ci-sa"
}
