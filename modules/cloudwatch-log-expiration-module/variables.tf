variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  type        = string
  default     = "us-east-1"
}

variable "runtime_lambda" {
  description = "Runtime to be used and its version"
  type        = string
  default     = "python3.8"
}

variable "cw_loggroups_excluded" {
  description = "List of log groups to be excluded from retention policy"
  type        = list(string)
  default     = []
}

variable "retention_days" {
  description = "Enter Number of days to set for CW log groups in AWS account. Eg: Days For Dev-1, Staging-1, Production-30. Valid values per AWS "
  type        = string
  validation {
    condition     = contains(["1", "3", "5", "7", "14", "30", "60", "90", "120", "150", "180", "365", "400", "545", "731", "1827", "2192", "2557", "2922", "3288", "3653"], var.retention_days)
    error_message = "Accepted only one value of the list: [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 2192, 2557, 2922, 3288, 3653]."
  }
}

variable "lambda_timeout" {
  description = "Timeout for lambda in seconds"
  type        = number
  default     = 30
  validation {
    condition     = var.lambda_timeout >= 3 && var.lambda_timeout <= 600 && floor(var.lambda_timeout) == var.lambda_timeout
    error_message = "Accepted values: [3-600] and must be an integer."
  }
}

variable "eventbridge_rule_enabled" {
  description = "Define if EventBridge rule is to be enabled or not"
  type        = bool
  default     = true
}
 