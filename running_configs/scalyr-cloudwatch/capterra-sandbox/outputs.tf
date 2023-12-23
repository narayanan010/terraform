output "cf_stack_id" {
    value = "${module.scalyr_cloudwatch_module.cf_stack_id}"
    description = "The ID of cloudformation stack created"
}

output "cf_outputs" {
  	value = "${module.scalyr_cloudwatch_module.cf_outputs}"
  	description = "A List of output structures."
}

output "ciphertext_blob" {
  	value = "${module.scalyr_cloudwatch_module.ciphertext_blob}"
  	description = "Base64 encoded ciphertext from KMS post encryption."
}

output "kms_arn" {
  	value = "${module.scalyr_cloudwatch_module.kms_arn}"
  	description = "The Amazon Resource Name (ARN) of the KMS key."
}

output "kms_key_id" {
  	value = "${module.scalyr_cloudwatch_module.kms_key_id}"
  	description = "The globally unique identifier for the key."
}