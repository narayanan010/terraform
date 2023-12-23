resource "aws_s3_bucket" "sem-ui-prd" {
  provider = aws
  bucket   = "sem-ui-prd"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = ["https://*.amazonaws.com"]
    max_age_seconds = "0"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = "0"
  }

  force_destroy = "false"

  grant {
    id          = "e0a126d9bfb219aa3b27eeef2e7838fd48881d621793787c418b59c21bc5c13d"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  object_lock_enabled = "false"
  request_payer       = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }

      bucket_key_enabled = "false"
    }
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}
