resource "aws_s3_bucket" "aws-athena-query-results-176540105868-us-east-1" {
  bucket        = "aws-athena-query-results-176540105868-us-east-1"
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
    app_environment     = "dev"
    application         = "Athena"
    created_by          = "Colin.taras@gartner.com"
    function            = "storage"
    network_environment = "dev"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "cap-lambda-code" {
  bucket        = "cap-lambda-code"
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
    app_environment     = "dev"
    application         = "lambda"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "storage"
    network_environment = "dev"
  }
}

resource "aws_s3_bucket" "capcon2010" {
  bucket        = "capcon2010"
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
    application = "capcon"
    created_by  = "Colin.taras@gartner.com"
    function    = "storage"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capcon2010.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra" {
  bucket        = "capterra"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [
      "http://127.0.0.1:3000",
      "http://localhost:3000",
      "http://localhost:3002",
      "http://localhost:6006",
      "http://localhost:6007",
      "http://localhost:5000",
      "http://localhost:5001",
      "http://localhost:6060",
      "https://vp-frontend.capstage.net",
      "https://digitalmarkets.capstage.net",
      "https://main-vex.capstage.net",
      "https://main-blue.capstage.net",
      "https://main-red.capstage.net",
      "https://main-orange.capstage.net",
      "https://capterra.com",
      "https://www.capterra.com",
      "https://*.chromatic.com",
      "https://capterra.github.io",
      "https://digitalmarkets.gartner.com"
    ]
    expose_headers  = []
    max_age_seconds = 0
  }

  grant {
    permissions = ["WRITE", "READ_ACP"]
    type        = "Group"
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }

  grant {
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }


  logging {
    target_bucket = "capterra"
    target_prefix = "logs/"
  }


  replication_configuration {
    role = "arn:aws:iam::176540105868:role/capterra-role-s3-capterra-bucket-rep"

    rules {
      destination {
        bucket = "arn:aws:s3:::capterra-rep"
      }

      id       = "YzU5MTljZjAtYzZiMC00Nzk0LWIxY2QtMDllNDM4OTRkNjg4"
      priority = "0"
      status   = "Enabled"
    }
  }

  tags = {
    application = "capterra_main"
    created_by  = "Colin.taras@gartner.com"
    function    = "storage"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-analytics" {
  bucket        = "capterra-analytics"
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
    application = "analytics"
    created_by  = "Colin.taras@gartner.com"
    function    = "analytics-data-store"
  }
}

resource "aws_s3_bucket" "capterra-backup" {
  bucket        = "capterra-backup"
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
    application = "cap-backup"
    created_by  = "Sarvesh.gupta@gartner.com"
    function    = "storage-backup"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-cloudtrail" {
  bucket        = "capterra-cloudtrail"
  force_destroy = "false"
  request_payer = "BucketOwner"

  grant {
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  grant {
    permissions = ["WRITE", "READ_ACP"]
    type        = "Group"
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:176540105868:alias/aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  tags = {
    application = "cloudtrail"
    created_by  = "Colin.taras@gartner.com"
    function    = "storage"
  }
}

resource "aws_s3_bucket" "capterra-development" {
  bucket        = "capterra-development"
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
    app_component       = "capterra-dev-bucket"
    app_environment     = "dev"
    application         = "cap-dev"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "dev-storage"
    network_environment = "dev"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-devops" {
  bucket        = "capterra-devops"
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
    app_environment     = "dev"
    application         = "cap-devops"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "devops"
    network_environment = "dev"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-infra-lambdas" {
  bucket        = "capterra-infra-lambdas"
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
    application = "lambdas"
    created_by  = "Colin.taras@gartner.com"
    function    = "lambda-code-storage"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-loadbalancer-logs" {
  bucket        = "capterra-loadbalancer-logs"
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
    application = "lb"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "lb_logs"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-oracle" {
  bucket        = "capterra-oracle"
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
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = "true"

    expiration {
      days                         = "365"
      expired_object_delete_marker = "false"
    }

    id     = "db_backups"
    prefix = "db_backups"

    transition {
      days          = "10"
      storage_class = "GLACIER"
    }
  }

  tags = {
    application = "oracle"
    created_by  = "Colin.taras@gartner.com"
    function    = "db"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-staging" {
  bucket        = "capterra-staging"
  force_destroy = "false"
  request_payer = "BucketOwner"


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }


  replication_configuration {
    role = "arn:aws:iam::176540105868:role/capterra-role-s3-capterra-bucket-rep"

    rules {
      destination {
        bucket             = "arn:aws:s3:::capterra-staging-rep-us-west-2"
        replica_kms_key_id = "arn:aws:kms:us-west-2:176540105868:alias/aws/s3"
      }

      id       = "N2FiMmI1ZmMtZTYxYi00N2JiLWI3NWEtY2Y1MjQ3YTBiZDc5"
      priority = "0"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = "true"
        }
      }

      status = "Enabled"
    }
  }

  tags = {
    app_component       = "capstage"
    app_environment     = "staging"
    application         = "cap-stage"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "origin_capstage"
    network_environment = "staging"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-storage-gateway" {
  bucket        = "capterra-storage-gateway"
  force_destroy = "false"
  request_payer = "BucketOwner"


  grant {
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["READ_ACP", "WRITE", "READ", "WRITE_ACP"]
    type        = "CanonicalUser"
  }


  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = "true"

    expiration {
      days                         = "365"
      expired_object_delete_marker = "false"
    }

    id = "storage-gateway-lifecycle-oracle-backup"

    noncurrent_version_expiration {
      days = "10"
    }

    prefix = "db_backups"

    transition {
      days          = "10"
      storage_class = "GLACIER"
    }
  }


  replication_configuration {
    role = "arn:aws:iam::176540105868:role/capterra-role-s3-replication"

    rules {
      destination {
        bucket        = "arn:aws:s3:::capterra-storage-gateway-rep"
        storage_class = "ONEZONE_IA"
      }

      id       = "YjMxMGJiNWUtMjc5Zi00NDI5LWJmZjctYWYxMDczMDc4YmI1"
      priority = "0"
      status   = "Enabled"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:176540105868:alias/aws/s3"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    application = "storage_gateway"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "cap_storage_gateway"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-test" {
  bucket        = "capterra-test"
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
    app_environment     = "test"
    application         = "admin"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "storage"
    network_environment = "test"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-wordpress" {
  bucket        = "capterra-wordpress"
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
    abort_incomplete_multipart_upload_days = "2"
    enabled                                = "true"

    expiration {
      days                         = "7"
      expired_object_delete_marker = "false"
    }

    id     = "Wordpress Backups"
    prefix = "dumps"
  }

  tags = {
    application         = "wordpress"
    created_by          = "Colin.taras@gartner.com"
    function            = "storage"
    network_environment = "prod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket" "capui" {
  bucket        = "capui"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "capterra-cloudtrail"
    target_prefix = "/capui"
  }

  tags = {
    application = "capui"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "webserver"
    product = "capui"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capui.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capui_capstage_net" {
  bucket        = "capui.capstage.net"
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
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }


  logging {
    target_bucket = "capterra-cloudtrail"
    target_prefix = "/capui"
  }

  tags = {
    app_component = "capterra_capui"
    application   = "capui"
    created_by    = "sarvesh.gupta@gartner.com"
    function      = "weborigin"
    product       = "capui"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capui.capstage.net.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "cf-templates-8798n9bveeda-us-east-1" {
  bucket        = "cf-templates-8798n9bveeda-us-east-1"
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
    app_environment     = "dev"
    application         = "CloudFormation"
    created_by          = "Colin.taras@gartner.com"
    function            = "automation"
    network_environment = "dev"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "config-bucket-176540105868" {
  bucket        = "config-bucket-176540105868"
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
    application = "awsconfig"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "monitoring_logs"
  }
}


resource "aws_s3_bucket" "equinix-storagegateway-nonprod" {
  bucket        = "equinix-storagegateway-nonprod"
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
    permissions = ["WRITE", "READ_ACP", "WRITE_ACP", "READ"]
    type        = "CanonicalUser"
  }

  tags = {
    app_component       = "storage_gateway"
    app_environment     = "nonprod"
    application         = "equinix"
    created_by          = "Colin.taras@gartner.com"
    function            = "storage_gateway"
    network_environment = "nonprod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "equinix-storagegateway-prod" {
  bucket        = "equinix-storagegateway-prod"
  force_destroy = "false"
  request_payer = "BucketOwner"

  grant {
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["WRITE_ACP", "READ", "WRITE", "READ_ACP"]
    type        = "CanonicalUser"
  }


  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 2
    enabled                                = "true"

    expiration {
      days                         = 31
      expired_object_delete_marker = "false"
    }

    id = "capterra-sg-lifecycle-001"

    noncurrent_version_expiration {
      days = 1
    }
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 1
    enabled                                = true
    id                                     = "temp_folder_backup_copy-lifecycle-002"
    prefix                                 = "temp_folder_backup_copy/"

    expiration {
      days                         = 1
      expired_object_delete_marker = false
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  replication_configuration {
    role = "arn:aws:iam::176540105868:role/capterra-role-s3-replication"

    rules {
      id       = "us-west-2"
      priority = "1"
      status   = "Disabled"

      destination {
        bucket             = "arn:aws:s3:::equnix-storagegateway-prd-rep"
        replica_kms_key_id = "arn:aws:kms:us-west-2:176540105868:key/084f2d8f-649a-46f4-b3ab-400614aac36b"
        storage_class      = "STANDARD_IA"
      }

      filter {
        prefix = "db_backups/"
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = "true"
        }
      }
    }

    rules {
      id       = "SRR_to_gdm-capterra-db-backup"
      priority = 2
      status   = "Disabled"

      destination {
        bucket             = "arn:aws:s3:::gdm-capterra-db-backup"
        replica_kms_key_id = "arn:aws:kms:us-east-1:176540105868:key/8d4cf506-5082-4bbb-b216-d3376612d7c6"
      }

      filter {
        prefix = "db_backups"
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:176540105868:key/8d4cf506-5082-4bbb-b216-d3376612d7c6"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    application = "equinix"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "equinix_storage_gateway"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "gdm-capterra-db-backup" {
  bucket        = "gdm-capterra-db-backup"
  force_destroy = "false"
  request_payer = "BucketOwner"

  lifecycle_rule {
    id                                     = "gdm-capterra-db-backup-toglacier"
    abort_incomplete_multipart_upload_days = 7
    enabled                                = "true"

    expiration {
      days                         = 380
      expired_object_delete_marker = "false"
    }

    noncurrent_version_expiration {
      days = 365
    }

    noncurrent_version_transition {
      days          = 1
      storage_class = "INTELLIGENT_TIERING"
    }

    noncurrent_version_transition {
      days          = 31
      storage_class = "GLACIER"
    }

    transition {
      days          = 15
      storage_class = "GLACIER"
    }
  }


  replication_configuration {
    role = "arn:aws:iam::176540105868:role/capterra-role-s3-replication"

    rules {
      id       = "YTk3ZDE0MzYtYTE5OC00ZjE3LTkzYjEtNDI1M2RlZTllNWM3"
      priority = "0"
      status   = "Enabled"

      destination {
        bucket             = "arn:aws:s3:::gdm-capterra-db-backup-rep"
        replica_kms_key_id = "arn:aws:kms:us-west-2:176540105868:key/25eec07d-613f-4006-8335-6ed2505eb9e5"
        storage_class      = "ONEZONE_IA"
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:176540105868:key/8d4cf506-5082-4bbb-b216-d3376612d7c6"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    application = "db"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "db_backup"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "gdm-capterra-db-data-archive" {
  bucket        = "gdm-capterra-db-data-archive"
  force_destroy = "false"
  request_payer = "BucketOwner"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = "true"

    expiration {
      days                         = "2555"
      expired_object_delete_marker = "false"
    }

    id = "glacier_after_14_days"

    noncurrent_version_expiration {
      days = "30"
    }

    transition {
      days          = "14"
      storage_class = "GLACIER"
    }
  }

  replication_configuration {
    role = "arn:aws:iam::176540105868:role/service-role/s3crr_role_for_gdm-capterra-db-data-archive-uw2_to_gdm-capterra-"
    rules {
      id       = "CapterraDataArchiveReplicationRole"
      priority = 1
      status   = "Enabled"

      destination {
        bucket             = "arn:aws:s3:::gdm-capterra-db-data-archive-uw2"
        replica_kms_key_id = "arn:aws:kms:us-west-2:176540105868:key/25eec07d-613f-4006-8335-6ed2505eb9e5"
        storage_class      = "GLACIER"
      }

      filter {
        tags = {}
      }

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app_component = "db"
    application   = "capterra-db"
    created_by    = "Colin.taras@gartner.com"
    function      = "db"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "softwaremarketingconference_com" {
  bucket        = "softwaremarketingconference.com"
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
    application = "sw_conf"
    function    = "web_origin"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "softwaremarketingconference.com.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket_public_access_block" "block_public_access_softwaremarketingconference_com" {
  bucket = aws_s3_bucket.softwaremarketingconference_com.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "www_softwaremarketingconference_com" {
  bucket        = "www.softwaremarketingconference.com"
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
    application = "sw_conference"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "web_origin"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    redirect_all_requests_to = "softwaremarketingconference.com"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "www.softwaremarketingconference.com.s3-website-us-east-1.amazonaws.com"
}


resource "aws_s3_bucket" "vp-reviews-reports-staging" {
  bucket        = "vp-reviews-reports-staging"
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
    app_environment     = "staging"
    application         = "vp"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "exported-reviews"
    network_environment = "staging"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp-reviews-reports-staging" {
  bucket = aws_s3_bucket.vp-reviews-reports-staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "vp-reviews-reports-prod" {
  bucket        = "vp-reviews-reports-prod"
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
    application = "vp"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "exported-reviews"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp-reviews-reports-prod" {
  bucket = aws_s3_bucket.vp-reviews-reports-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "vp-clicks-reports-staging" {
  bucket        = "vp-clicks-reports-staging"
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
    app_environment     = "staging"
    application         = "vp"
    created_by          = "sarvesh.gupta@gartner.com"
    function            = "vp-clicks-reports"
    network_environment = "staging"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp-clicks-reports-staging" {
  bucket = aws_s3_bucket.vp-clicks-reports-staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "vp-clicks-reports-prod" {
  bucket        = "vp-clicks-reports-prod"
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
    application = "vp"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "vp-clicks-reports"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp-clicks-reports-prod" {
  bucket = aws_s3_bucket.vp-clicks-reports-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "vp-frontend-production" {
  bucket        = "vp-frontend-production"
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
    application = "vp"
    created_by  = "sarvesh.gupta@gartner.com"
    function    = "vp-frontend"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp-frontend-production" {
  bucket = aws_s3_bucket.vp-frontend-production.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############################################
###Bidding bucket 
##############################################

resource "aws_s3_bucket" "ppc-rankins-exports-prod" {
  bucket        = "ppc-rankins-exports-prod"
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
    application = "Bidding"
    created_by  = "suman.sindhu@gartner.com"
    function    = "Bidding"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.ppc-rankins-exports-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "ppc-rankins-exports-staging" {
  bucket        = "ppc-rankins-exports-staging"
  acl           = "private"
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
    app_environment     = "staging"
    application         = "Bidding"
    created_by          = "suman.sindhu@gartner.com"
    function            = "Bidding"
    network_environment = "staging"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_staging" {
  bucket = aws_s3_bucket.ppc-rankins-exports-staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "bidding-staging" {
  bucket        = "bidding-staging"
  force_destroy = "false"
  acl           = "private"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app  = "bidding"
    Team = "Vx"
    env  = "staging"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "bidding-staging" {
  bucket = aws_s3_bucket.bidding-staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "bidding-prod" {
  bucket        = "bidding-prod"
  force_destroy = "false"
  acl           = "private"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app  = "bidding"
    Team = "Vx"
    env  = "prod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "bidding-prod" {
  bucket = aws_s3_bucket.bidding-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "uvp-pendo-data" {
  bucket        = "uvp-pendo-data"
  force_destroy = "false"
  acl           = "private"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app  = "vp"
    Team = "Vx"
    env  = "stage"
    network_environment = "stage"
    environment = "stage"
    app_environment = "stage"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "uvp-pendo-data" {
  bucket = aws_s3_bucket.uvp-pendo-data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "autobidder-stage" {
  bucket        = "autobidder-stage"
  force_destroy = "false"
  acl           = "private"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app  = "autobidder"
    Team = "Frodo"
    env  = "stage"
    network_environment = "stage"
    environment = "stage"
    app_environment = "stage"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "autobidder-stage" {
  bucket = aws_s3_bucket.autobidder-stage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "autobidder-prod" {
  bucket        = "autobidder-prod"
  force_destroy = "false"
  acl           = "private"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app  = "autobidder"
    Team = "Frodo"
    env  = "prod"
    network_environment = "prod"
    environment = "prod"
    app_environment = "prod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
  
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_public_access_block" "autobidder-prod" {
  bucket = aws_s3_bucket.autobidder-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "vp-exports-staging" {
  bucket        = "vp-exports-staging"
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
    app_environment     = "staging"
    application         = "vp"
    created_by          = "suman.sindhu@gartner.com"
    function            = "vp-exported"
    network_environment = "staging"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp_exports_staging" {
  bucket = aws_s3_bucket.vp-exports-staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "vp-exports-prod" {
  bucket        = "vp-exports-prod"
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
    app_environment     = "prod"
    application         = "vp"      
    created_by          = "suman.sindhu@gartner.com"
    function            = "vp-exported"
    network_environment = "prod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
 
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_vp_exports_prod" {
  bucket = aws_s3_bucket.vp-exports-prod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "shortlist" {
  bucket        = "shortlist-images"
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
    app_environment     = "prod"
    application         = "shortlist"      
    created_by          = "suman.sindhu@gartner.com"
    function            = "shortlist-images"
    network_environment = "prod"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
 
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_shortlist" {
  bucket = aws_s3_bucket.shortlist.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
