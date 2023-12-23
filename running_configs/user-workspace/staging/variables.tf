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
  type = list(any)
}

variable "uw_signout_urls" {
  type = list(any)
}

# Tag vars
variable "region" {
  type        = string
  description = "Default hosted AWS region"
}

variable "monitoring" {
  type        = bool
  description = "Enable monitoring"
}

variable "terraform_managed" {
  type        = bool
  description = "Iac terraform managed"
}

variable "application" {
  type        = string
  description = ""
}

variable "technology" {
  type        = string
  description = ""
}

variable "vertical" {
  type        = string
  description = ""
}

variable "stage" {
  type        = string
  description = ""
}

variable "platform" {
  type        = string
  description = ""
}

variable "product" {
  type        = string
  description = ""
}

variable "environment" {
  type        = string
  description = ""
}

variable "app_contacts" {
  type        = string
  description = ""
}

variable "function" {
  type        = string
  description = ""
}

variable "business_unit" {
  type        = string
  description = ""
}

variable "created_by" {
  type        = string
  description = ""
}