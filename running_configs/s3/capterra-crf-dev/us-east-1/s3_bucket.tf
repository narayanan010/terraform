resource "aws_s3_bucket" "config-bucket-377773991577" {
  bucket        = "config-bucket-377773991577"
  force_destroy = "false"
  request_payer = "BucketOwner"

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

resource "aws_s3_bucket" "gdm-crf-getapp-dev" {
  bucket        = "gdm-crf-getapp-dev"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  grant {
    id          = "1617578049debbd8e0191fd8937ec8068199a6da131940cf526ad75573f56c91"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }


  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "0"
    enabled                                = "true"

    expiration {
      days                         = "90"
      expired_object_delete_marker = "false"
    }

    id = "log"

    tags = {
      AutoClean   = "true"
      Environment = "dev"
      Product     = "crf"
      vertical    = "getapp"
    }
  }


  tags = {
    Environment = "dev"
    Product     = "crf"
    vertical    = "getapp"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}
