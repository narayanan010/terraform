output "cf_stack_id" {
    value = "${aws_cloudformation_stack.scalyr.id}"
    description = "The ID of cloudformation stack created"
}

output "cf_outputs" {
  	value = "${aws_cloudformation_stack.scalyr.outputs}"
  	description = "A List of output structures."
}

output "ciphertext_blob" {
  	value = "${aws_kms_ciphertext.akmsct.ciphertext_blob}"
  	description = "Base64 encoded ciphertext from KMS post encryption."
}

output "kms_arn" {
  	value = "${aws_kms_key.akk.arn}"
  	description = "The Amazon Resource Name (ARN) of the KMS key."
}

output "kms_key_id" {
  	value = "${aws_kms_key.akk.key_id}"
  	description = "The globally unique identifier for the key."
}