output "config_rule_id" {
	value = module.aws-config.config_rule_id
	description = "The ID of AWS Config Rule"	
}

output "config_recorder_id" {
	value = module.aws-config.config_recorder_id
	description = "Name of AWS Config recorder"
}

output "s3_bucket_name" {
	value = module.aws-config.s3_bucket_name
	description = "Name of s3 bucket used for AWS Config"
}
