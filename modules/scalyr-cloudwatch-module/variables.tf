variable "region_aws" {
	description = "region_aws"
	default = "us-east-1"
}

#Cloudformation Variables
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
#	description = "iamusername to be passed to KMS key policy to allow usage"
#	default = "scalyr_user"
#}

variable "scalyrplainapikeytoencrypt" {
	description = "scalyrplainapikeytoencrypt to be passed to KMS to get ciphertext"
}