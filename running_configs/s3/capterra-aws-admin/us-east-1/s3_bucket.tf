resource "aws_s3_bucket" "capterra-cloudtrail-logs" {
  bucket        = "capterra-cloudtrail-logs"
  force_destroy = "false"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = "true"

    expiration {
      days                         = "455"
      expired_object_delete_marker = "false"
    }

    id = "Glacier - 90 days"

    noncurrent_version_expiration {
      days = "375"
    }

    noncurrent_version_transition {
      days          = "10"
      storage_class = "GLACIER"
    }

    transition {
      days          = "90"
      storage_class = "GLACIER"
    }
  }

  replication_configuration {
    role = "arn:aws:iam::237884149494:role/service-role/s3crr_role_for_capterra-cloudtrail-logs_to_capterra-cloudtrail-l"

    rules {
      destination {
        bucket             = "arn:aws:s3:::capterra-cloudtrail-logs-rep"
        replica_kms_key_id = "arn:aws:kms:us-west-2:237884149494:alias/aws/s3"
        storage_class      = "STANDARD_IA"
      }

      id       = "MGIzYmQyMjctOTJiNS00ZTkzLTk2NDItMTVhNjZkYjY4ZTYw"
      priority = "0"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = "true"
        }
      }

      status = "Enabled"
    }
  }

  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:237884149494:key/cd8c2bdd-7220-47bf-8758-f79d28b65814"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    NAME = "capterra-cloudtrail-logs"
  }
}




resource "aws_s3_bucket" "capterra-terraform-state" {
  bucket        = "capterra-terraform-state"
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
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    NAME = "capterra-terraform-state"
  }
}




resource "aws_s3_bucket" "config-bucket-237884149494" {
  bucket        = "config-bucket-237884149494"
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

  tags = {
    NAME = "config-bucket-237884149494"
  }
}


resource "aws_s3_bucket" "cptra-terraform-state" {
  bucket        = "cptra-terraform-state"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:237884149494:key/cd8c2bdd-7220-47bf-8758-f79d28b65814"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    NAME = "cptra-terraform-state"
  }
}


resource "aws_s3_bucket" "capterra-lambda-zips" {
  bucket = "capterra-lambda-zips"

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
}
