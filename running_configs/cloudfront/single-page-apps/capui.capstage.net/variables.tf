variable "name" {
    type = "string"
    description = "Name of application. E.g: cfr"
    default = "capui-capstage-net"  
}

variable "runtime_lambda" {
    type = "string"
    description = "Runtime to be used and its version"
  	default     = "nodejs12.x"
}

variable "region" {
    type = "string"
    description = "Region description"
  	default     = "us-east-1"
}

variable "aws_account_id" {
    type = "string"
    description = "AWS-Account-ID. The data caller identity else uses root account when fetched automatically."
  	default     = "176540105868"
}