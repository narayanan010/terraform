variable "name" {
  type        = string
  description = "Name of application. E.g: serverless-app1"
  default     = "reviews.upcity.com"
}

variable "oai" {
  type        = string
  description = "OAI to be attached"
  default     = "E16H4GJPGRAPB6"
}

variable "aws_wafv2_web_acl_name" {
  type        = string
  description = "WAF Name to assign to the distribution."
}

variable "modulecaller_assume_role_deployer_account" {
  type        = string
  description = "Assume Role from the account in which resources are to be deployed to. This can be any AWS account"
}

variable "cf_origin_access_control" {
  type        = string
  description = "Origin Access Control (OAC)"
}

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

variable "vertical" {
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