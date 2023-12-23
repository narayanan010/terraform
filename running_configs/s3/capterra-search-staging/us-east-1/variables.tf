variable "principal_list" {
  type        = list(string)
  description = "List of principals to use for s3:* Allow on a bucket"
}
