variable "msk_cluster_name" {
  type        = string
  description = "Name of the MSK cluster"
}

variable "msk_kafka_version" {
  type        = string
  description = "Desired Kafka software version"
}

variable "msk_number_of_broker_nodes" {
  type        = number
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
}

variable "msk_broker_instance_type" {
  type        = string
  description = "The instance type to use for the kafka brokers"
}

variable "msk_broker_ebs_size" {
  type        = number
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "msk_broker_client_subnets" {
  type        = list(any)
  description = "A list of subnets to connect to in client VPC"
}

variable "msk_encryption_kms_key" {
  type        = string
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
}

variable "msk_cw_logs_retention" {
  type        = number
  description = "MSK CloudWatch log group retention in days"
}

variable "memory_db_cluster_name" {
  type        = string
  description = "Name of the Memory DB cluster"
}

variable "memory_db_engine_version" {
  type        = string
  description = "Version number of the Redis engine to be used for the cluster. Downgrades are not supported."
}

variable "memory_db_node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the cluster."
}

variable "memory_db_num_shards" {
  type        = number
  description = "The number of shards in the cluster"
}

variable "memory_db_num_replicas_per_shard" {
  type        = number
  description = " The number of replicas to apply to each shard, up to a maximum of 5"
}

variable "memory_db_tls_enabled" {
  type        = string
  description = "A flag to enable in-transit encryption on the cluster"
}

variable "memory_db_maintenance_window" {
  type        = string
  description = "Specifies the weekly time range during which maintenance on the cluster is performed"
}

variable "memory_db_snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which MemoryDB begins taking a daily snapshot of your shard"
}

variable "memory_db_snapshot_retention_limit" {
  type        = number
  description = "The number of days for which MemoryDB retains automatic snapshots before deleting them. When set to 0, automatic backups are disabled"
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

variable "stage" {
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
variable "system_risk_class" {
  type        = string
  description = ""
}

variable "app_component" {
  type        = string
  description = ""
}

variable "alerts_to" {
  type        = string
  description = "Default target for alerts"
  default     = ""
}
