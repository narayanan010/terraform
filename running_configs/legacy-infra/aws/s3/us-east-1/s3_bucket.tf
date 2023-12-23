resource "aws_s3_bucket" "aws-athena-query-results-176540105868-us-east-1" {
  acl            = "private"
  arn            = "arn:aws:s3:::aws-athena-query-results-176540105868-us-east-1"
  bucket         = "aws-athena-query-results-176540105868-us-east-1"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }
  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "cap-lambda-code" {
  acl            = "private"
  arn            = "arn:aws:s3:::cap-lambda-code"
  bucket         = "cap-lambda-code"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capcon2010" {
  acl            = "private"
  arn            = "arn:aws:s3:::capcon2010"
  bucket         = "capcon2010"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
        terraform_managed = "True"
  }
  versioning {
    enabled    = false
    mfa_delete = false
  }

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capcon2010.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra"
  bucket         = "capterra"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  logging {
    target_bucket = "capterra"
    target_prefix = "logs/"
  }

  region = "us-east-1"

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

  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-backup" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-backup"
  bucket         = "capterra-backup"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-cloudtrail" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-cloudtrail"
  bucket         = "capterra-cloudtrail"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags           {}

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-development" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-development"
  bucket         = "capterra-development"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-devops" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-devops"
  bucket         = "capterra-devops"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-infra-lambdas" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-infra-lambdas"
  bucket         = "capterra-infra-lambdas"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"

  tags {
    ENVIRONMENT = "PRODUCTION"
    terraform_managed = "true"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-lambda-code" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-lambda-code"
  bucket         = "capterra-lambda-code"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
    tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-loadbalancer-logs" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-loadbalancer-logs"
  bucket         = "capterra-loadbalancer-logs"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "0"
    enabled                                = true

    expiration {
      days                         = "90"
      expired_object_delete_marker = false
    }

    id   = "ArchiveAndExpireLogs"
    tags {}

    transition {
      days          = "14"
      storage_class = "GLACIER"
    }
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"
    tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-log-streaming" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-log-streaming"
  bucket         = "capterra-log-streaming"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-oracle" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-oracle"
  bucket         = "capterra-oracle"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = true

    expiration {
      days                         = "365"
      expired_object_delete_marker = false
    }

    id     = "db_backups"
    prefix = "db_backups"
    tags {}

    transition {
      days          = "10"
      storage_class = "GLACIER"
    }
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-pardot-backup" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-pardot-backup"
  bucket         = "capterra-pardot-backup"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "2"
    enabled                                = true

    expiration {
      days                         = "30"
      expired_object_delete_marker = false
    }

    id   = "Delete old logs"
    tags {}
  }

  region = "us-east-1"

  replication_configuration {
    role = "arn:aws:iam::176540105868:role/service-role/s3crr_role_for_capterra-pardot-backup_to_capterra-pardo-rep-us-w"

    rules {
      destination {
        bucket = "arn:aws:s3:::capterra-pardo-rep-us-west-2"
      }

      
      id       = "capterra-role-pardot-backup-replication"
      priority = "1"
      status   = "Enabled"
    }
  }

  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-staging" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-staging"
  bucket         = "capterra-staging"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"

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
          enabled = true
        }
      }

      status = "Enabled"
    }
  }

  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-storage-gateway" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-storage-gateway"
  bucket         = "capterra-storage-gateway"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = true

    expiration {
      days                         = "365"
      expired_object_delete_marker = false
    }

    id = "storage-gateway-lifecycle-oracle-backup"

    noncurrent_version_expiration {
      days = "10"
    }

    prefix = "db_backups"
    tags {}

    transition {
      days          = "10"
      storage_class = "GLACIER"
    }
  }

  region = "us-east-1"

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

  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-test" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-test"
  bucket         = "capterra-test"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-wordpress" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-wordpress"
  bucket         = "capterra-wordpress"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "2"
    enabled                                = true

    expiration {
      days                         = "7"
      expired_object_delete_marker = false
    }

    id     = "Wordpress Backups"
    prefix = "dumps"
    tags   {}
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"
   tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capui" {
  acl            = "private"
  arn            = "arn:aws:s3:::capui"
  bucket         = "capui"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  logging {
    target_bucket = "capterra-cloudtrail"
    target_prefix = "/capui"
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"

  tags {
    ENVIRONMENT = "prd"
    product     = "capui"
    vertical    = "capterra"
    terraform_managed = "true"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capui.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capui--capstage--net" {
  acl            = "private"
  arn            = "arn:aws:s3:::capui.capstage.net"
  bucket         = "capui.capstage.net"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  logging {
    target_bucket = "capterra-cloudtrail"
    target_prefix = "/capui"
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"

  tags {
    ENVIRONMENT = "prd"
    product     = "capui"
    vertical    = "capterra"
    terraform_managed = "true"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capui.capstage.net.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "cf-templates-8798n9bveeda-us-east-1" {
  acl            = "private"
  arn            = "arn:aws:s3:::cf-templates-8798n9bveeda-us-east-1"
  bucket         = "cf-templates-8798n9bveeda-us-east-1"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "config-bucket-176540105868" {
  acl            = "private"
  arn            = "arn:aws:s3:::config-bucket-176540105868"
  bucket         = "config-bucket-176540105868"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags           {}

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "elasticbeanstalk-us-east-1-176540105868" {
  acl            = "private"
  arn            = "arn:aws:s3:::elasticbeanstalk-us-east-1-176540105868"
  bucket         = "elasticbeanstalk-us-east-1-176540105868"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "equinix-storagegateway-nonprod" {
  acl            = "private"
  arn            = "arn:aws:s3:::equinix-storagegateway-nonprod"
  bucket         = "equinix-storagegateway-nonprod"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
   tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "equinix-storagegateway-prod" {
  acl            = "private"
  arn            = "arn:aws:s3:::equinix-storagegateway-prod"
  bucket         = "equinix-storagegateway-prod"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = true

    expiration {
      days                         = "0"
      expired_object_delete_marker = true
    }

    id = "capterra-sg-lifecycle-001"

    noncurrent_version_expiration {
      days = "90"
    }

    noncurrent_version_transition {
      days          = "1"
      storage_class = "INTELLIGENT_TIERING"
    }

    tags {}

    transition {
      days          = "1"
      storage_class = "INTELLIGENT_TIERING"
    }
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "gdm-capterra-db-backup" {
  acl            = "private"
  arn            = "arn:aws:s3:::gdm-capterra-db-backup"
  bucket         = "gdm-capterra-db-backup"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = true

    expiration {
      days                         = "380"
      expired_object_delete_marker = false
    }

    id   = "gdm-capterra-db-backup-toglacier"
    tags {}

    transition {
      days          = "15"
      storage_class = "GLACIER"
    }
  }

  region = "us-east-1"

  replication_configuration {
    role = "arn:aws:iam::176540105868:role/capterra-role-s3-replication"

    rules {
      destination {
        bucket        = "arn:aws:s3:::gdm-capterra-db-backup-rep"
        storage_class = "STANDARD_IA"
      }

      id       = "YTk3ZDE0MzYtYTE5OC00ZjE3LTkzYjEtNDI1M2RlZTllNWM3"
      priority = "0"
      status   = "Enabled"
    }
  }

  request_payer = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "softwaremarketingconference--com" {
  acl            = "private"
  arn            = "arn:aws:s3:::softwaremarketingconference.com"
  bucket         = "softwaremarketingconference.com"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
  tags {
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "softwaremarketingconference.com.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "www--softwaremarketingconference--com" {
  acl            = "private"
  arn            = "arn:aws:s3:::www.softwaremarketingconference.com"
  bucket         = "www.softwaremarketingconference.com"
  force_destroy  = false
  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"
   tags  { 
      terraform_managed = "True"
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }

  website {
    redirect_all_requests_to = "softwaremarketingconference.com"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "www.softwaremarketingconference.com.s3-website-us-east-1.amazonaws.com"
}
