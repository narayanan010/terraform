resource "aws_cognito_user_pool" "uw_user_pool_stg" {
  name                       = "cap-user-workspace-${var.stage}"
  email_verification_subject = "Verify Your Email Address"
  email_verification_message = "<p style=\"line-height:1.5\">Hi there.</p><p style=\"line-height:1.5\">Before you can log in to your Capterra account we need to verify your email address. Your verification code is {####}.</p><p style=\"line-height:1.5\">Thanks,</p><p style=\"line-height:1.5\">Team Capterra</p><img src=\"https://capterra.s3.amazonaws.com/assets/images/logos/capterra.png\" width=\"122\" height=\"29\"/><p style=\"line-height:1.5\"><b>Why do we do this?</b> Asking you to verify your email address protects you from receiving emails, accounts, and password updates you didn’t request.</p>\n"
  sms_authentication_message = "Your authentication code is {####}. "
  sms_verification_message   = "Your verification code is {####}. "
  username_attributes        = ["email"]


  lambda_config {
    post_confirmation   = var.post_confirmation_lambda_arn
    post_authentication = var.post_authentication_lambda_arn
    pre_sign_up         = "arn:aws:lambda:us-east-1:273213456764:function:user-workspace-staging-userPreSignup"
  }

  auto_verified_attributes = ["email"]
  #alias_attributes = ["email"]
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
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
    mutable             = "false"
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
  schema {
    attribute_data_type = "String"
    mutable             = "true"
    name                = "signUpLocation"
    required            = "false"

    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }
  tags = {
    ENVIRONMENT       = "STAGING"
    project           = "userworkspace"
    terraform_managed = "true"
    vertical          = "capterra"
    Team              = "Spacenine"
  }

  # lifecycle {
  #   ignore_changes = [
  #     admin_create_user_config[0].unused_account_validity_days
  #   ]
  # }
}

resource "aws_cognito_user_pool_client" "uw_client_stg" {
  name                         = "userworkspace-staging-client"
  user_pool_id                 = aws_cognito_user_pool.uw_user_pool_stg.id
  explicit_auth_flows          = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  refresh_token_validity       = "30"
  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_identity_pool" "uw_pool" {
  identity_pool_name               = "uwid"
  allow_unauthenticated_identities = false
  developer_provider_name          = "LinkedIn"
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.uw_client_stg.id
    provider_name           = aws_cognito_user_pool.uw_user_pool_stg.endpoint
    server_side_token_check = false
  }

}