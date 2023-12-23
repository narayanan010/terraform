resource "aws_s3_bucket" "capterra-rep" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-rep"
  bucket         = "capterra-rep"
  force_destroy  = false
  hosted_zone_id = "Z3BJ6K6RIION7M"
  region         = "us-west-2"
  request_payer  = "BucketOwner"

  tags {
    Vertical = "capterra-dr"
    comment  = "Replication target for capterra bucket"
    stage    = "prd"
    terraform_managed = "True"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-staging-rep-us-west-2" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-staging-rep-us-west-2"
  bucket         = "capterra-staging-rep-us-west-2"
  force_destroy  = false
  hosted_zone_id = "Z3BJ6K6RIION7M"
  region         = "us-west-2"
  request_payer  = "BucketOwner"

  tags {
    ENVIRONMENT = "STAGING"
    PROJECT     = "DR"
    VERTICAL    = "CAPTERRA"
    terraform_managed = "TRUE"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "capterra-storage-gateway-rep" {
  acl            = "private"
  arn            = "arn:aws:s3:::capterra-storage-gateway-rep"
  bucket         = "capterra-storage-gateway-rep"
  force_destroy  = false
  hosted_zone_id = "Z3BJ6K6RIION7M"

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled                                = true

    expiration {
      days                         = "0"
      expired_object_delete_marker = true
    }

    id = "Transition to glacier"

    noncurrent_version_expiration {
      days = "10"
    }

    tags {}

    transition {
      days          = "2"
      storage_class = "GLACIER"
    }
  }

  region        = "us-west-2"
  request_payer = "BucketOwner"
  tags          {}

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

resource "aws_s3_bucket" "gdm-capterra-db-backup-rep" {
  acl            = "private"
  arn            = "arn:aws:s3:::gdm-capterra-db-backup-rep"
  bucket         = "gdm-capterra-db-backup-rep"
  force_destroy  = false
  hosted_zone_id = "Z3BJ6K6RIION7M"
  region         = "us-west-2"
  request_payer  = "BucketOwner"
  tags           {
    terraform_managed = "TRUE"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }
}
