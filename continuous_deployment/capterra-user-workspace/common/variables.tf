variable "modulecaller_source_region" {
  default     = "us-east-1"
  description = "Region of Primary Bucket that needs to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
  default     = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer"
  description = "Assume Role from the account that holds CF distribution, ACM Cert, Primary and Secondary Buckets"
}

variable "stage" {
  description = "stage to be passed to module. Eg: dev, staging etc"
  default     = "staging"
}

variable "name" {
  type        = string
  description = "Name of application. E.g: serverlessapp"
  default     = "capterra-user-workspace"
}


# Custom Tag
variable "tag_application" {
  type        = string
  description = "Tag for service application"
  default     = "user-workspace"
}

