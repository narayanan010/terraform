resource "aws_s3_bucket" "s3_stormbreaker" {
  bucket        = "gdm-crf-${var.app_environment}-${var.application}"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
      tags_all
    ]
  }
}

# create bucket ACL :
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.s3_stormbreaker.id
  acl    = "private"
}

# block public access :
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.s3_stormbreaker.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# encrypt bucket using SSE-S3:
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.s3_stormbreaker.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
