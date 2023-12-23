### Common
variable "vertical" {
  type = string
}

variable "application" {
  type = string
}

variable "environment" {
  type = string
}

### Global cluster

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "Aurora database engine version"
  type        = string
  default     = "14.8"
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = ""
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = true
}

### RDS Cluster

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless"
  type        = string
  default     = "global"
}

variable "database_name" {
  description = "Aurora database name"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "primary_instance_class" {
  description = "Instance type to use for primary"
  type        = string
  default     = "db.r4.large"
}

variable "secondary_instance_class" {
  description = "Instance type to use for secondary"
  type        = string
  default     = "db.r4.large"
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

## Primary

variable "primary_cluster_instance_count" {
  description = "Number of DB nodes to create in each region"
  default     = 1
}


variable "primary_instance_id" {
  description = "Name for the DB cluster or DB instance for secondary region"
  default     = ""
}

variable "instance_identifier_primary" {
  description = "Name for the DB cluster or DB instance for primary region"
  default     = ""
}

variable "primary_cluster_id" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = ""
}

variable "primary_kms_arn" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

variable "performance_insights_enabled" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}
## Secondary

variable "secondary_cluster_instance_count" {
  description = "Number of DB nodes to create in each region"
  default     = 1
}

variable "secondary_instance_id" {
  description = "Name for the DB cluster or DB instance for secondary region"
  default     = ""
}

variable "secondary_cluster_id" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = ""
}

variable "secondary_db_subnet_group_name" {
  description = "The existing subnet group name to use"
  type        = string
  default     = ""
}

variable "secondary_kms_arn" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

## subnet variables ##

variable "primary_subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs for primary cluster"
}

variable "secondary_subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs for secondary cluster"
}
## parameter variables ##

variable "param_family" {
  type        = string
  default     = "aurora-postgresql14"
  description = "List of VPC parameter"
}

## security group

variable "primary_vpc_id" {
  type        = string
  description = "VPC ID to create the Security Group for Primary RDS (e.g. `vpc-a22222ee`)"
}

variable "secondary_vpc_id" {
  type        = string
  description = "VPC ID to create the Security Group for Secondary RDS (e.g. `vpc-a22222ee`)"
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

## KMS key

variable "primary_kms_key" {
  description = "Boolean to decide if KMS key need to be created or not for primary DB"
  type        = bool
  default     = false
}

variable "secondary_kms_key" {
  description = "Boolean to decide if KMS key need to be created or not for secondary DB"
  type        = bool
  default     = false
}

# ## Tags ##

# #tags. These values can be overwritten when calling module.
# variable "tag_application" {
#   type = string
# }
# variable "tag_app_component" {
#   type    = string
#   default = "storage"
# }
# variable "tag_function" {
#   type    = string
#   default = "database"
# }
# variable "tag_business_unit" {
#   type    = string
#   default = ""
# }
# variable "tag_app_environment" {
#   type = string
# }
# variable "tag_app_contacts" {
#   type    = string
#   default = "opsteam@capterra.com"
# }
# variable "tag_created_by" {
#   type    = string
#   default = "fabio.perrone@gartner.com"
# }
# variable "tag_system_risk_class" {
#   type    = string
#   default = "3"
# }
# variable "tag_region" {
#   type = string
# }
# variable "tag_network_environment" {
#   type = string
# }
# variable "tag_monitoring" {
#   type    = string
#   default = ""
# }
# variable "tag_terraform_managed" {
#   type    = string
#   default = "true"
# }
# variable "tag_vertical" {
#   type = string
# }
# variable "tag_product" {
#   type    = string
#   default = "rds"
# }
# variable "tag_environment" {
#   type = string
# }