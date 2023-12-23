
variable "namespace" {
  description = "Namespace (Namespace. EG Capterra, GetApp, etc`)"
  type        = "string"
  default = "capterra"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (Application Name)"
  type        = "string"
  default     = "capterra"
}

variable "region" {
  description = "Region to build this VPC in"
  type = "string"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {

  }
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "CIDR for the VPC"  
}

variable "vpc_instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = "true"
}

variable "vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default     = "true"
}

variable "vpc_enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC"
  default     = "false"
}

variable "vpc_enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC"
  default     = "false"
}

variable "vpc_assign_generated_ipv6_cidr_block" {
  type = "string"
  default = "true"
}