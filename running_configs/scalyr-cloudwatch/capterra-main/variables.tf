#Basic Variables
variable "modulecaller_source_region" {
	default = "us-east-1"
	description = "Region to be passed to Provider info where calling module"
}

variable "modulecaller_assume_role_primary_account" {
	default = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
	description = "Assume Role from the account in which resources are to be deployed to"
}



#Below are variables from within module.
variable "region_aws" {
	description = "This is region where tf template is to be deployed"
 	default     = "us-east-1"
}

variable "BaseUrl" {
  description = "Base URL of the Scalyr API"
  default = "https://www.scalyr.com"
}

variable "AutoSubscribeLogGroups" {
  description = "Automatically subscribe the logGroups defined in LogGroupOptions to the CloudWatch Streamer Lambda function, Valid value: true/false"
  default = "false"
}

variable "Debug" {
  description = "Enable debug logging of each request, Valid value: true/false"
  default = "false"
}

variable "WriteLogsKey" {
  description = "Use this or WriteLogsKeyEncrypted. The Scalyr API key that allows write access to Scalyr logs"
  default = ""
}

variable "WriteLogsKeyEncrypted" {
  description = "Use this or WriteLogsKey. The encrypted Scalyr API key that allows write access to Scalyr logs. To get the encrypted key use AWS KMS"
  default = ""
}

variable "LogGroupOptions" {
  description = "Valid JSON string to customise log delivery"
  default = "{}"
}

variable "template_url" {
  description = "URL of the scalyr template. Currently picked from https://github.com/scalyr/scalyr-aws-serverless/tree/master/cloudwatch_logs#deployment"
  default = "https://scalyr-aws-serverless.s3.amazonaws.com/cloudwatch_logs/cloudwatch-logs-1.0.8.yml"
}


#KMS variables
#variable "iamusername" {
#  description = "iamusername to be passed to KMS key policy to allow usage"
#  default = "scalyr_user"
#}

variable "scalyrplainapikeytoencrypt" {
  description = "SCALYR API Key to be passed to KMS to get ciphertext that will be passed in encrypted form to cf-template"
}