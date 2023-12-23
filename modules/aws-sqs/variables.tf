# SQS

variable "queue_name" {
  description = "Name of the Queue to be created"
  default     = ""
}

variable "visibility_timeout" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = "30"
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)."
  default     = ""
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  default     = ""
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message (from 60 (1 minute) to 1209600 (14 days) )"
  default     = "345600"
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)."
  default     = ""
}

#variable "sqs_managed_sse_enabled" {
#description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys."
#default     = false
#}


variable "fifo_queue" {
  description = "Boolean designating a FIFO queue. If not set, it defaults to false making it standard"
  default     = false
}

variable "content_duplication" {
  description = "Enables content-based deduplication for FIFO queues"
  default     = false
}

variable "duplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values are 'messageGroup' and 'queue' "
  default     = "messageGroup"
}

variable "fifo_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are 'perQueue' (default) and 'perMessageGroupId' "
  default     = "perQueue"
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN for the KMS encryption key"
  default     = ""
}

variable "kms_key_req" {
  description = "Boolean to decide if KMS key need to be created or not"
  type        = bool
  default     = false
}

variable "role_name_sqs" {
  description = "Role to be added in Principal policy"
}

variable "redrivePermission" {
  description = "Permissions to be given 'byQueue, denyAll, allowAll'"
  default     = "allowAll"
}

variable "maxReceiveCount" {
  description = "Maximum receive message count in integer"
  type        = number
  default     = 10
}

variable "dlq_required" {
  description = "Deadletter queue is required or not. Boolean value"
  type        = bool
  default     = false
}

variable "dlq_alert_required" {
  description = "Alert to Slack for deadletter queue is required or not. Boolean value"
  type        = bool
  default     = false
}

variable "slack_alert_webhook_parameter" {
  description = "The Slack webhook to be used for alarms"
  type        = string
  default     = ""
}

variable "application" {
  description = "Name of the application to be part of the Slack notification"
  type        = string
  default = ""
}

variable "environment" {
  description = "Name of the environment to be part of the Slack notification"
  type        = string
  default     = ""
}

variable "vertical" {
  description = "Name of the vertical"
  type        = string
  default     = "capterra"
}

/*variable "source_queues" {
  description = "List of queues to be added in DLQ if redrivePermission = byQueue"
  type = list(string)
  default = []
}*/
