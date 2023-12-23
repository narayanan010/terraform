variable "modulecaller_source_region" {
  default     = "us-west-2"
  description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default     = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"
  description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}
