variable "region" {
  type        = string
  description = "Default hosted AWS region"
}

variable "availability_zone" {
  type        = string
  description = "Default availability_zone"
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

# CloudWatch variables
variable "cw_logs_retention" {
  type        = string
  description = ""
}

variable "cw_prefix" {
  type        = string
  description = ""
}
