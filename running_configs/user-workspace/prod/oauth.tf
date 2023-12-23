resource "aws_cognito_user_pool" "uw_oauth_user_pool" {
  name                       = "cap-user-workspace-${var.stage}-${var.pool_type}"
  email_verification_subject = "Verify Your Email Address"
  email_verification_message = "<p style=\"line-height:1.5\">Hi there.</p><p style=\"line-height:1.5\">Before you can log in to your Capterra account we need to verify your email address. Your verification code is {####}.</p><p style=\"line-height:1.5\">Thanks,</p><p style=\"line-height:1.5\">Team Capterra</p><img src=\"https://capterra.s3.amazonaws.com/assets/images/logos/capterra.png\" width=\"122\" height=\"29\"/><p style=\"line-height:1.5\"><b>Why do we do this?</b> Asking you to verify your email address protects you from receiving emails, accounts, and password updates you didn’t request.</p>\n"
  sms_authentication_message = "Your authentication code is {####}. "
  sms_verification_message   = "Your verification code is {####}. "
  username_attributes        = ["email"]

  lambda_config {
    post_confirmation   = var.post_confirmation_lambda_arn
    post_authentication = var.post_authentication_lambda_arn
  }

  auto_verified_attributes = ["email"]
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    reply_to_email_address = "no-reply@capterra.com"
    source_arn             = var.uw_ses_arn
    email_sending_account  = "DEVELOPER"
  }

  admin_create_user_config {

    invite_message_template {
      email_message = "Welcome to Capterra User Workspace, {username} .  Your verification code is {####}."
      email_subject = "Capterra User Workspace Verification Code"
      sms_message   = "Your username is {username} and temporary password is {####}. "
    }
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }
  schema {
    attribute_data_type = "String"
    mutable             = "true"
    required            = "true"
    name                = "email"
    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = "true"
    name                = "company_name"
    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = "true"
    name                = "company_size"

    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = "true"
    name                = "industry"

    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = "true"
    name                = "sub_industry"

    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    mutable             = "true"
    name                = "job_title"

    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "uw_google_client" {
  name                                 = "userworkspace-oauth-client-${var.stage}"
  user_pool_id                         = aws_cognito_user_pool.uw_oauth_user_pool.id
  explicit_auth_flows                  = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  supported_identity_providers         = ["COGNITO", "Google"]
  logout_urls                          = var.uw_google_signout_urls
  callback_urls                        = var.uw_callback_urls
  allowed_oauth_scopes                 = ["openid", "profile", "email", "aws.cognito.signin.user.admin"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = "true"

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 7
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

resource "aws_cognito_user_pool_domain" "workspaceauth_capstage_002" {
  domain          = var.user_workspace_custom_domain_name
  certificate_arn = var.uw_acm_certificate_arn
  user_pool_id    = aws_cognito_user_pool.uw_oauth_user_pool.id
}

resource "aws_cognito_identity_provider" "uw_google_provider_002" {
  user_pool_id  = aws_cognito_user_pool.uw_oauth_user_pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes              = "profile email openid"
    client_id                     = var.google_client_id
    client_secret                 = var.google_client_secret
    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = "true"
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email            = "email"
    username         = "sub"
    "email_verified" = "email_verified"
    "picture"        = "picture"
    "family_name"    = "family_name"
    "given_name"     = "given_name"
  }
}

