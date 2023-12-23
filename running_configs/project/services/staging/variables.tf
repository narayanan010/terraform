variable "modulecaller_source_region" {
  type        = string
  description = "Region where aws-config runs passed to Provider info when calling module"
}

variable "modulecaller_assume_role_primary_account" {
  type        = string
  description = "Assume Role from the account that runs AWS Config and other dependencies to be created"
}
variable "application" {
  type = string
}
