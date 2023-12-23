variable "post_confirmation_lambda_arn" {
    type = string
}

variable "post_authentication_lambda_arn" {
    type = string
}

variable "uw_acm_certificate_arn" {
    type = string
}

variable "user_workspace_custom_domain_name" {
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

variable "uw_ses_arn" {
    type = string
}

variable "uw_callback_urls" {
    type = list(string)
}

variable "uw_signout_urls" {
    type = list(string)
}

