variable "cross_region_key_arn" {
  description = "The key to be used to encrypt in cross region ami copies."
  default = ""
}
variable "dlm_lifecycle_role_arn" {
  description = "The role to be used by the DLM service."
  default = ""
}

variable "vertical" {
  description = "Vertical this resource belongs to (capterra/getapp/softwareadvice)"
  default     = "capterra"
  type = string
  validation {
    condition     = contains(["capterra", "getapp", "softwareadvice"], var.vertical)
    error_message = "The valid values are: capterra/getapp/softwareadvice."
  } 
}

variable "prod_backup_enabled" {
  default     = false
  type = bool
  description = "Define if the backup plans are enabled for prod"
}

variable "staging_backup_enabled" {
  default     = false
  type = bool
  description = "Define if the backup plans are enabled for staging"
}

variable "dev_backup_enabled" {
  default     = false
  type = bool
  description = "Define if the backup plans are enabled for dev"
}
