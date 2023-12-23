# AWS infrastructure details
################################################

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

# EC2 instance details
################################################

variable "ec2_security_groups" {
  type        = list(any)
  description = "EC2 security groups"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ec2_key_name" {
  type        = string
  description = "EC2 key name"
}

variable "ec2_ami" {
  type        = string
  description = "EC2 private AMI"
}

variable "ec2_subnets" {
  type        = string
  description = "EC2 private subnets"
}


# Deploymen tag definition
################################################

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
