variable "modulecaller_source_region" {
  type        = string
  default     = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
  type        = string
  default     = "arn:aws:iam::350125959894:role/gdm-dev-full_role"
  description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets"
}

variable "modulecaller_assume_role_dns_account" {
  type        = string
  default     = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
  description = "Assume Role from the account that holds DNS/R53 hosted Zone (Capterra Account in our case mostly)"
}

variable "application" {
  type        = string
  default     = ""
  description = ""
}

variable "app_environment" {
  type        = string
  default     = ""
  description = ""
}

variable "cf_origin_access_control" {
  type        = string
  description = "Origin Access Control (OAC)"
  default     = ""
}