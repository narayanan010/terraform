variable "post_confirmation_lambda_arn" {
  type = string
}

variable "post_authentication_lambda_arn" {
  type = string
}

variable "pre_signup_lambda_arn" {
  type = string
}

variable "certificate_arn_ga" {
  type = string
}

variable "certificate_arn_sa" {
  type = string
}

variable "user_workspace_custom_domain_name_ga" {
  type = string
}

variable "user_workspace_custom_domain_name_sa" {
  type = string
}

variable "stage" {
  type = string
}

variable "environment" {
  type = string
}

variable "pool_type" {
  type = string
}

variable "google_client_id" {
  type = string
}

variable "google_client_secret" {
  type = string
}

variable "google_client_id_ga" {
  type = string
}

variable "google_client_secret_ga" {
  type = string
}

variable "google_client_id_sa" {
  type = string
}

variable "google_client_secret_sa" {
  type = string
}

variable "uw_ses_arn" {
  type = string
}

variable "uw_callback_urls" {
  type = list(string)
}

variable "uw_signout_urls" {
  type = list(string)
}
