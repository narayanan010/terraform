resource "aws_s3_bucket" "capterra-cloudtrail-logs-rep" {
  bucket        = "capterra-cloudtrail-logs-rep"
  force_destroy = "false"

  #  This is default grant, which will be present regardless, in the abscene of other grants. However, due to some bug, it shows up in plan every time. Thus, it's commented out
  #  grant {
  #    id          = "c666fdbbf3adfcb6c0e6fe398bdb83fdfb151163b086c830a31fd8995272dc96" # 237884149494 capterra-aws-admin
  #    permissions = ["FULL_CONTROL"]
  #    type        = "CanonicalUser"
  #  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = "true"

    expiration {
      days                         = "90"
      expired_object_delete_marker = "false"
    }

    id = "Expire after 90 days"

    noncurrent_version_expiration {
      days = "90"
    }
  }

  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    NAME = "capterra-cloudtrail-logs-rep"
  }
}
