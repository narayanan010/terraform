output "tags" {
  value       = local.tags
  description = "This is map of tags"
}

output "label_s3" {
  value       = local.label_s3
  description = "Labeling for S3 bucket"
}
