resource "aws_s3_bucket" "capterra-terraform-state-888548925459" {
  bucket = "capterra-terraform-state-888548925459"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}
