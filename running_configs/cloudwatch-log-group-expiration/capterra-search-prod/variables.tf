variable "modulecaller_source_region" {
  type        = string
  default     = "us-east-1"
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to"
  default     = "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin"
  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.modulecaller_assume_role_primary_account))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

variable "lambda_timeout" {
  type        = number
  description = "Timeout for lambda in seconds"
  default     = 30
}
