variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "runtime_lambda" {
  description = "Runtime to be used and its version"
  default     = "python3.9"
}
