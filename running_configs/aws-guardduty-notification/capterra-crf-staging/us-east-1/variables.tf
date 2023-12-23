variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default     = "arn:aws:iam::350125959894:role/gdm-admin-access"
  description = "Assume Role from the account that runs to create the resources"
}

variable "vertical" {
  default = "capterra"
}
