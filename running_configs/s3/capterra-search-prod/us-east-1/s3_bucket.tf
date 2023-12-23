resource "aws_s3_bucket" "capterra-terraform-state-296947561675" {
  bucket = "capterra-terraform-state-296947561675"

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

resource "aws_s3_bucket" "cwlogs-296947561675" {
  bucket = "cwlogs-296947561675"

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
      days                         = "365"
      expired_object_delete_marker = "false"
    }

    id     = "tf-s3-lifecycle-20180815145538384900000001"
    prefix = "*/*"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "gc1-296947561675-netskope-s3" {
  bucket = "gc1-296947561675-netskope-s3"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    AppComponent       = "n/a"
    AppOwner           = "dlitcloudops@gartner.com"
    AppVersion         = "n/a"
    Application        = "bootstrap"
    BackupDisable      = "false"
    BusinessUnit       = "shared"
    Cluster            = "false"
    CostCenter         = "shared"
    CreatedBy          = "dlitcloudops@gartner.com"
    DataClassification = "n/a"
    Environment        = "nonprod"
    Function           = "n/a"
    Region             = "us-east-1"
    Service            = "n/a"
    StartTime          = "n/a"
    StopTime           = "n/a"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "forms-as-a-service-prd" {
  bucket = "forms-as-a-service-prd"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

    tags = {
    AppOwner           = "capterra_devops"
    BusinessUnit       = "GDM"
    CreatedBy          = "sarvesh.gupta@gartner.com"
    Environment        = "production"
    Region             = "us-east-1"
    Service            = "FaaS"
  }

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


  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "forms-as-a-service-prd.s3-website-us-east-1.amazonaws.com"
}
