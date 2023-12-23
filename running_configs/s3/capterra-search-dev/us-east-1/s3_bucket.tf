resource "aws_s3_bucket" "ai-reviews" {
  bucket = "ai-reviews"

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
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "ai-reviews.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "alexathon" {
  bucket = "alexathon"

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

resource "aws_s3_bucket" "bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l" {
  bucket = "bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l"

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
    id          = "b5dd193847e87e7adfdd6ecda920df952b85481487d2a5cc6704e59176a6d484"
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

resource "aws_s3_bucket" "capterra-devops_com" {
  bucket = "capterra-devops.com"

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
    error_document = "404.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capterra-devops.com.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra-panorama" {
  bucket = "capterra-panorama"

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

resource "aws_s3_bucket" "capterra-search-dev" {
  bucket = "capterra-search-dev"

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
  website_endpoint = "capterra-search-dev.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra-search-dev-cloudtrail-148797279579" {
  bucket = "capterra-search-dev-cloudtrail-148797279579"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l"
    target_prefix = "cloudtraillogs"
  }


  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "capterra-search-dev-config-service-148797279579" {
  bucket = "capterra-search-dev-config-service-148797279579"

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

resource "aws_s3_bucket" "capterra-search-dev-devops-us-east-1" {
  bucket = "capterra-search-dev-devops-us-east-1"

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

resource "aws_s3_bucket" "capterra-search-dev-error-page" {
  bucket = "capterra-search-dev-error-page"

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
    redirect_all_requests_to = "https://www.capterra.com"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capterra-search-dev-error-page.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra-search-dev-redirect-bucket" {
  bucket = "capterra-search-dev-redirect-bucket"

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
    redirect_all_requests_to = "https://www.capstage.net"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "capterra-search-dev-redirect-bucket.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "capterra-terraform-state-148797279579" {
  bucket = "capterra-terraform-state-148797279579"

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

resource "aws_s3_bucket" "central-review-form-dev1" {
  bucket = "central-review-form-dev1"

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
  website_endpoint = "central-review-form-dev1.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "cf-templates-wmoif3kd83uh-us-east-1" {
  bucket = "cf-templates-wmoif3kd83uh-us-east-1"

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

resource "aws_s3_bucket" "cwlogs-148797279579" {
  bucket = "cwlogs-148797279579"

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

    id     = "tf-s3-lifecycle-20180806133026158400000001"
    prefix = "*/*"
  }


  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "dev-cap-eloqua-ftp" {
  bucket = "dev-cap-eloqua-ftp"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    app = "userworkspace"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
}

resource "aws_s3_bucket" "directory-page-ui-dev" {
  bucket = "directory-page-ui-dev"

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
  website_endpoint = "directory-page-ui-dev.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "gc1-148797279579-netskope-s3" {
  bucket = "gc1-148797279579-netskope-s3"

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

resource "aws_s3_bucket" "lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15" {
  bucket = "lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15"

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

  website {
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "react-performance-research" {
  bucket = "react-performance-research"

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
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "react-performance-research.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "sa-ppl-dev-arlen" {
  bucket = "sa-ppl-dev-arlen"

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

resource "aws_s3_bucket" "spotlight-ui-dev" {
  bucket = "spotlight-ui-dev"

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
  website_endpoint = "spotlight-ui-dev.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "vendor-page-ui-dev" {
  bucket = "vendor-page-ui-dev"

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
  website_endpoint = "vendor-page-ui-dev.s3-website-us-east-1.amazonaws.com"
}

resource "aws_s3_bucket" "www_capterra-devops_com" {
  bucket = "www.capterra-devops.com"

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
    redirect_all_requests_to = "http://capterra-devops.com"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "www.capterra-devops.com.s3-website-us-east-1.amazonaws.com"
}
