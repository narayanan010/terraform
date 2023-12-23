output "step_function_arn" {
    value = aws_sfn_state_machine.this.arn
    description = "The ARN of the Step function created."
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.backup_storage.id
    description = "The ARN of the S3 bucket to save backups."
}