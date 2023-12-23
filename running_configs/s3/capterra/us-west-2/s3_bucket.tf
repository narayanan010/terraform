resource "aws_s3_bucket" "capterra-rep" {
  bucket        = "capterra-rep"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app_component       = "capterra"
    app_environment     = "prod"
    application         = "cap-dr"
    comment             = "Replication target for capterra bucket"
    created_by          = "Colin.taras@gartner.com"
    function            = "dr"
    network_environment = "prod"
    stage               = "prd"
    vertical            = "capterra-dr"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-staging-rep-us-west-2" {
  bucket        = "capterra-staging-rep-us-west-2"
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
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["WRITE"]
    type        = "CanonicalUser"
  }

  tags = {
    ENVIRONMENT         = "STAGING"
    PROJECT             = "DR"
    app_component       = "capterra"
    application         = "capstage"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "capstage_dr"
    network_environment = "stg"
    vertical            = "capterra"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-storage-gateway-rep" {
  bucket        = "capterra-storage-gateway-rep"
  force_destroy = "false"
  request_payer = "BucketOwner"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 7
    enabled                                = "true"

    expiration {
      days                         = 0
      expired_object_delete_marker = "true"
    }

    id = "Transition to glacier"

    noncurrent_version_expiration {
      days = 10
    }

    transition {
      days          = 2
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-west-2:176540105868:alias/aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    app_component       = "capterra"
    app_environment     = "prod"
    application         = "cap-storage-gateway"
    created_by          = "Colin.taras@gartner.com"
    function            = "storage_gw"
    network_environment = "prod"
  }
}

resource "aws_s3_bucket" "capterra-loadbalancer-dr-logs" {
  bucket        = "capterra-loadbalancer-dr-logs"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "0"
    enabled                                = "true"

    expiration {
      days                         = "30"
      expired_object_delete_marker = "false"
    }

    id = "ArchiveAndExpireLogs"

    noncurrent_version_expiration {
      days = "365"
    }
  }

  tags = {
    app_component       = "capterra-lb-dr"
    app_environment     = "prod"
    application         = "lb"
    created_by          = "narayanan.narasimhan@gartner.com"
    function            = "lb_logs"
    network_environment = "prod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "equnix-storagegateway-prd-rep" {
  bucket        = "equnix-storagegateway-prd-rep"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 7
    enabled                                = "true"

    expiration {
      days                         = 31
      expired_object_delete_marker = "false"
    }

    id = "capterra-sg-lifecycle-rep-001"

    noncurrent_version_expiration {
      days = 31
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    app_component       = "capterra"
    app_environment     = "prod"
    application         = "equinix"
    created_by          = "Colin.taras@gartner.com"
    function            = "storage_gateway"
    network_environment = "prod"
  }
}

resource "aws_s3_bucket" "gdm-capterra-db-backup-rep" {
  bucket        = "gdm-capterra-db-backup-rep"
  force_destroy = "false"
  request_payer = "BucketOwner"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 7
    enabled                                = "true"

    expiration {
      days                         = 380
      expired_object_delete_marker = "false"
    }

    id = "gdm-capterra-db-backup-rep--toglacier"

    transition {
      days          = 15
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-west-2:176540105868:alias/aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    app_component       = "capterra"
    app_environment     = "prod"
    application         = "db"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "db_backup"
    network_environment = "prod"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "gdm-capterra-db-data-archive-uw2" {
  bucket        = "gdm-capterra-db-data-archive-uw2"
  force_destroy = "false"
  request_payer = "BucketOwner"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-west-2:176540105868:key/25eec07d-613f-4006-8335-6ed2505eb9e5"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id                                     = "Glacier - 7days"
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = true

    expiration {
      days                         = "2555"
      expired_object_delete_marker = "false"
    }
    noncurrent_version_expiration {
      days = "7"
    }

    transition {
      days          = "7"
      storage_class = "GLACIER"
    }
  }

  replication_configuration {
    role = "arn:aws:iam::176540105868:role/service-role/s3crr_role_for_gdm-capterra-db-data-archive-uw2_to_gdm-capterra-"

    rules {
      id       = "CapterraDataArchiveReplicationRole"
      priority = "1"
      status   = "Disabled"

      filter {}

      destination {
        bucket             = "arn:aws:s3:::gdm-capterra-db-data-archive"
        storage_class      = "GLACIER"
        replica_kms_key_id = "arn:aws:kms:us-east-1:176540105868:key/c11ae2e7-2f5c-4b95-85f0-f85e778475e9"
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = merge({
    created_by          = "dan.oliva@gartner.com",
    function            = "db_archive",
    ENVIRONMENT         = "PRODUCTION",
    network_environment = "prod",
    app_component       = "db",
    app_environment     = "prod"
  }, var.tags)

}