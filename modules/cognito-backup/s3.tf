resource "aws_s3_bucket" "backup_storage" {
  bucket = "cognito-user-pool-${var.environment}-backup-${data.aws_caller_identity.current.account_id}-${var.region}"

  tags = {
    Name        = "cognito-user-pool-${var.environment}-backup-${data.aws_caller_identity.current.account_id}-${var.region}"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "delete_after_30days" {
  bucket = aws_s3_bucket.backup_storage.bucket

  rule {
    id = "30 - delete"

    filter {}

    expiration {
      days = 30
    }

    status = "Enabled"
  }
}  

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backup_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}
