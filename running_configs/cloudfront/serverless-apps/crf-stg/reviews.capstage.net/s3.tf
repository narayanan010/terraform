#Bucket and Policy
resource "aws_s3_bucket" "tfer--central-002D-review-002D-form-002D-stg" {
  bucket = "central-review-form-stg"

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
    terraform_managed = "true"
  }

  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

}


resource "aws_s3_bucket_policy" "tfer--central-002D-review-002D-form-002D-stg" {
  bucket = aws_s3_bucket.tfer--central-002D-review-002D-form-002D-stg.id
  policy = data.aws_iam_policy_document.s3_policy_bucket.json
}

data "aws_iam_policy_document" "s3_policy_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.tfer--central-002D-review-002D-form-002D-stg.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/EAZGRKOW2G7RF"
      ]
    }
  }
}

resource "aws_s3_bucket" "crf-staging-cdn" {
  bucket = "crf-staging-cdn"
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
    terraform_managed = "true"
  }
  versioning {
    enabled    = "false"
    mfa_delete = "false"
  }
  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "crf-staging-cdn" {
  bucket = aws_s3_bucket.crf-staging-cdn.id
  policy = data.aws_iam_policy_document.s3_policy_cdn_bucket.json
}

data "aws_iam_policy_document" "s3_policy_cdn_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.crf-staging-cdn.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/EAZGRKOW2G7RF",
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/EXDIOT4JLQSZ4",
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/E21QHSVCMH7JLN",
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/E2HQ5Y3S7JETJE"
      ]
    }
  }
}