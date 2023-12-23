variable "user_pool_name" {
  type = string
}


variable "email_message" {
  type = map(string)
}


variable "post_confirmation_lambda_arn" {
  type = string
}


variable "pre_signup_lambda_arn" {
  type = string
}


variable "uw_ses_arn" {
  type = string
}


variable "user_pool_tags" {
  type = map(string)
}


variable "user_pool_client_name" {
  type = string
}


variable "identity_pool_name" {
  type = string
}
