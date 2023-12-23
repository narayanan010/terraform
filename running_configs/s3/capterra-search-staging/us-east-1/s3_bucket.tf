resource "aws_s3_bucket" "blog-ssi-poc" {
  bucket = "blog-ssi-poc"

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

resource "aws_s3_bucket" "bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z" {
  bucket = "bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  grant {
    permissions = ["WRITE", "READ_ACP"]
    type        = "Group"
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }

  grant {
    id          = "eb1b1753d1a6453ba8870d8ef2baae9355003128fe5db406cc015833c520577c"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }


  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "0"
    enabled                                = "true"

    expiration {
      days                         = "2555"
      expired_object_delete_marker = "false"
    }

    id = "Transition90daysRetain7yrs"

    transition {
      days          = "90"
      storage_class = "GLACIER"
    }
  }


  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-search-staging-cloudtrail-273213456764" {
  bucket = "capterra-search-staging-cloudtrail-273213456764"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z"
    target_prefix = "cloudtraillogs"
  }


  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-search-staging-config-service-273213456764" {
  bucket = "capterra-search-staging-config-service-273213456764"

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

resource "aws_s3_bucket" "capterra-search-staging-devops-us-east-1" {
  bucket = "capterra-search-staging-devops-us-east-1"

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

resource "aws_s3_bucket" "capterra-search-stg" {
  bucket = "capterra-search-stg"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
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
  website_endpoint = "capterra-search-stg.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra-terraform-state-273213456764" {
  bucket = "capterra-terraform-state-273213456764"

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

resource "aws_s3_bucket" "capterra-user-workspace-staging" {
  bucket = "capterra-user-workspace-staging"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
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
    error_document = "workspace/index.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capterra-user-workspace-staging.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "cwlogs-273213456764" {
  bucket = "cwlogs-273213456764"

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

    id     = "tf-s3-lifecycle-20180815141709587100000001"
    prefix = "*/*"
  }


  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "directory-page-ui-stg" {
  bucket = "directory-page-ui-stg"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
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
  website_endpoint = "directory-page-ui-stg.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "gc1-273213456764-netskope-s3" {
  bucket = "gc1-273213456764-netskope-s3"

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

resource "aws_s3_bucket" "global-nav-mf-stg" {
  bucket = "global-nav-mf-stg"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
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
  website_endpoint = "global-nav-mf-stg.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "spotlight-ui-stg" {
  bucket = "spotlight-ui-stg"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
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
  website_endpoint = "spotlight-ui-stg.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "vendor-page-ui-stg" {
  bucket = "vendor-page-ui-stg"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
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
  website_endpoint = "vendor-page-ui-stg.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "vp-ppl-qa" {
  bucket = "vp-ppl-qa"

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

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "vp-ppl-qa.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra-search-staging-RBR-frodo-team-us-east-1" {
  bucket = "capterra-search-staging-rbr-frodo-team"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    tag_application         = "static-ui"
    tag_app_component       = "RBR Process"
    tag_function            = "Frodo-team"
    tag_business_unit       = "gdm"
    tag_app_environment     = "dev"
    tag_app_contacts        = "capterra_devops"
    tag_created_by          = "suman.sindhu@gartner.com"
    tag_system_risk_class   = 3
    tag_region              = "us-east-1"
    tag_network_environment = "staging"
    tag_monitoring          = "false"
    tag_terraform_managed   = "true"
    tag_vertical            = "capterra"
    tag_product             = "RBR process"
    tag_environment         = "staging"
      }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}
