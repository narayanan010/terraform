resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket        = local.ecs_name
  force_destroy = "false"
}

resource "aws_s3_bucket_versioning" "codedeploy_bucket" {
  bucket = aws_s3_bucket.codedeploy_bucket.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codedeploy_bucket" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "codedeploy_bucket" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "codedeploy_bucket" {
  bucket = aws_s3_bucket.codedeploy_bucket.id
  acl    = "private"
}
