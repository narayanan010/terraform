variable "modulecaller_source_region" {
  type        = string
  description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "cname_aliases" {
  type        = list(string)
  description = "List of CNAMEs to be associated with the Cloudfront distribution."
  default     = []
}

variable "hosted_zone_id" {
  type        = string
  description = "The hosted zone in which the entry dns should be added."
}
