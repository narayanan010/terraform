data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "backup_target" {
  bucket_prefix = "capterra-route53-backup-${data.aws_caller_identity.current.account_id}-"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.backup_target.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "bucket_security" {
  bucket = aws_s3_bucket.backup_target.bucket
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_backup" {
  bucket = aws_s3_bucket.backup_target.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "delete_after_30days" {
  bucket = aws_s3_bucket.backup_target.bucket

  rule {
    id = "30 - delete"

    filter {}

    expiration {
      days = 30
    }

    status = "Enabled"
  }
}  
