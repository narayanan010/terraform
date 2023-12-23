variable "region" {
  type        = string
  description = "Region to run module in"
}

######################################################
##  Elasticache cluster Vars
######################################################
variable "cluster_id" {
  type        = string
  description = "(Required) Group identifier. ElastiCache converts this name to lowercase."
}

variable "engine" {
  type        = string
  description = "(Required unless replication_group_id is provided) Name of the cache engine to be used for this cache cluster. Valid values for this parameter are memcached or redis."
  default     = "redis"
}

variable "node_type" {
  type        = string
  description = "(Required unless replication_group_id is provided) The compute and memory capacity of the nodes. See Available Cache Node Types for supported node types."
  default     = "cache.t3.micro"

  validation {
    condition     = can(regex("^cache\\..*\\..*", var.node_type))
    error_message = "Only nodes starting with cache. are allowed."
  }
}

variable "parameter_group_name" {
  type        = string
  description = "(Required unless replication_group_id is provided) Name of the parameter group to associate with this cache cluster."
  default = "default.redis7.cluster.on"
}

variable "engine_version" {
  type        = string
  description = "(Optional) Version number of the cache engine to be used. See Describe Cache Engine Versions in the AWS Documentation center for supported versions"
  default     = "7.0"
}

variable "port" {
  type        = number
  description = "(Optional) The port number on which each of the cache nodes will accept connections. For Memcache the default is 11211, and for Redis the default port is 6379. Cannot be provided with replication_group_id."
  default     = 6379
}

variable "maintenance_window" {
  type        = string
  description = "(Optional) Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00"
  default     = "sat:03:30-sun:01:00"
}

variable "snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 3

  validation {
    condition     = can(regex("^[0-9]$|^[0-9][0-9]$", var.snapshot_retention_limit))
    error_message = "Invalid input, for snapshot retention. Allowed values are between [0-99]."
  }
}

variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "01:30-03:20"
}



######################################################
##  Replication Group Vars
######################################################
variable "automatic_failover_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. Automatic failover (Not available for T1/T2 instances)"
}

variable "multi_az_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable Multi-AZ"
}


variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}

variable "cluster_size" {
  type        = number
  description = "Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
  validation {
    condition     = can(regex("^[0-9]$|^[0-9][0-9]$", var.cluster_size))
    error_message = "Invalid input, cluster nodes should be a number."
  }
}

variable "transit_encryption_enabled" {
  type        = bool
  default     = true
  description = "Enable TLS"
}

variable "auth_token" {
  type        = string
  description = "Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars. Redis Auth can only be enabled within an Amazon VPC"
  default     = null
}

variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 1
  validation {
    condition     = can(regex("^[0-5]$", var.cluster_mode_replicas_per_node_group))
    error_message = "Invalid input for replica nodes in each node group."
  }
}

variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 1
  validation {
    condition     = can(regex("^[1-9]$", var.cluster_mode_num_node_groups))
    error_message = "Invalid input for number of node groups (shards)."
  }
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable encryption at rest"
}

variable "kms_key_id" {
  type        = string
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true."
  default     = ""
}

variable "subnet_list_to_add_to_subnet_group" {
  type        = list(any)
  description = "List of subnet to add to subnet group for Redis"
}

variable "elasticache_existing_subnet_group_name" {
  type        = string
  description = "Existing Subnet group name for the ElastiCache instance"
  default     = ""
}

variable "add_subnet_group" {
  type        = bool
  description = "true, if want to add existing subnet group or create new subnet group. false, if dont want to create new subnet group or use existing subnet group"
  default     = true
}

variable "add_cluster_azs" {
  type        = bool
  description = "true if you want to add Availability Zones manually under Running Configuration"
  default     = false
}

variable "cluster_az_ids" {
  type        = list(any)
  description = "List of AZ IDs to add to Elasticache cluster under preferred_cache_cluster_azs"
  default     = [""]
}

######################################################
##  Security Group Vars
######################################################
variable "vpc_id_for_sg" {
  type        = string
  description = "VPC ID"
}

variable "use_existing_security_groups" {
  type        = bool
  description = "Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into"
  default     = false
}

variable "existing_security_groups" {
  type        = list(string)
  default     = []
  description = "List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module. These are added as Source security groups"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module"
}

variable "allowed_prefix_list" {
  type        = list(string)
  default     = []
  description = "List of prefix list allowed by ingress to the cluster's Security Group created in the module"
}

variable "enable_kms_key_rotation" {
  type = bool
  default = false
  description = "Boolean to control KMS Key rotation"
}