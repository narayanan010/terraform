resource "aws_cognito_user_pool" "uw_user_pool_dev" {
  name                       = "cap-user-workspace-dev"
  email_verification_subject = "Capterra User Workspace Verification Code"
  email_verification_message = "Welcome to Capterra User Workspace. Your verification code is {####}."
  sms_authentication_message = "Your authentication code is {####}. "
  sms_verification_message   = "Your verification code is {####}. "
  username_attributes        = ["email"]

  lambda_config {
    post_authentication = "arn:aws:lambda:us-east-1:148797279579:function:user-workspace-ivan-userPostAuthentication"
    post_confirmation   = "arn:aws:lambda:us-east-1:148797279579:function:user-workspace-ivan-userPostConfirmation"
  }

  auto_verified_attributes = ["email"]
  #alias_attributes = ["email"]
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    reply_to_email_address = "community@capterra.com"
    source_arn             = "arn:aws:ses:us-east-1:148797279579:identity/software@capterra.com"
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

  tags = {
    ENVIRONMENT       = "DEVELOPMENT"
    terraform_managed = "true"
    vertical          = "capterra"
    project           = "userworkspace"


  }
}

resource "aws_cognito_user_pool_client" "uw_client_dev" {
  name                = "userworkspace-staging-client"
  user_pool_id        = aws_cognito_user_pool.uw_user_pool_dev.id
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  #write_attributes = ["email"]
  refresh_token_validity       = "30"
  supported_identity_providers = ["COGNITO"]

}

resource "aws_cognito_identity_pool" "uw_pool" {
  identity_pool_name               = "uwid"
  allow_unauthenticated_identities = false
  developer_provider_name          = "LinkedIn"
  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.uw_client_dev.id
    provider_name           = aws_cognito_user_pool.uw_user_pool_dev.endpoint
    server_side_token_check = false
  }
}

# resource "aws_cognito_identity_provider" "uw_google_provider" {
#   user_pool_id  = aws_cognito_user_pool.uw_user_pool_dev.id
#   provider_name = "Google"
#   provider_type = "Google"

#   provider_details = {
#     authorize_scopes = "profile email openid"
#     client_id        = "756105029491-j9qsfi9p3fkias2qhqabjj8oq0va0qbe.apps.googleusercontent.com"
#     client_secret    = "xAkfIvqkOgpCBy0ep4ZOTioq"
#   }

#     attribute_mapping = {
#     email    = "email"
#     username = "sub"
#   }
# }