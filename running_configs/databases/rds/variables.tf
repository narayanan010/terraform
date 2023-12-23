# Common
variable "vertical" {
  type = string
}
variable "environment" {
  type = string
}
variable "application" {
  type = string
}

# Database
variable "database_name" {
  type = string
}
variable "engine" {
  type = string
}
variable "engine_mode" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "primary_instance_class" {
  type = string
}
variable "secondary_instance_class" {
  type = string
}
variable "performance_insights_enabled" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

# Storage & Backup
variable "storage_encrypted" {
  type = bool
}
variable "backup_retention_period" {
  type = number
}
variable "skip_final_snapshot" {
  type = bool
}

# Subnet Groups
variable "primary_subnet_ids" {
  type = list(string)
}
variable "secondary_subnet_ids" {
  type = list(string)
}

# Primary
variable "primary_cluster_instance_count" {
  type = number
}
variable "primary_kms_arn" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

# Secondary
variable "secondary_cluster_instance_count" {
  type = number
}
variable "secondary_kms_arn" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

# Security groups
variable "primary_vpc_id" {
  type = string
}
variable "secondary_vpc_id" {
  type = string
}
variable "primary_security_group_ingress_rule" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    sg_ids      = list(string)
    description = string
  }))
}
variable "secondary_security_group_ingress_rule" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    sg_ids      = list(string)
    description = string
  }))
}

variable "deploy_account_role" {
  description = "Role to deploy resources"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

# Tags
variable "tag_app_component" {
  type = string
}
variable "tag_function" {
  type = string
}
variable "tag_business_unit" {
  type = string
}
variable "tag_app_contacts" {
  type = string
}
variable "tag_created_by" {
  type = string
}
variable "tag_system_risk_class" {
  type = string
}
variable "tag_monitoring" {
  type = string
}
variable "tag_terraform_managed" {
  type = string
}
variable "tag_vertical" {
  type = string
}
variable "tag_product" {
  type = string
}
variable "tag_default_region" {
  type = string
}
