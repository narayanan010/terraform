variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default     = "arn:aws:iam::738909422062:role/assume-crf-production-admin"
  description = "Assume Role from the account that runs to create the resources"
}

variable "vertical" {
  default = "capterra"
}
