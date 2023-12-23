variable "user_pool_name" {
  type = string
}


variable "email_message" {
  type = map(string)
}


variable "post_confirmation_lambda_arn" {
  type = string
}


variable "post_authentication_lambda_arn" {
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


variable "user_pool_client" {
  type = map(list(string))
}


variable "user_pool_domain" {
  type = map(string)
}


variable "identity_provider" {
  type = map(string)
}
