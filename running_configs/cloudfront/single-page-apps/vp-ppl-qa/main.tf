resource "aws_cloudfront_distribution" "tfer--E2ISACMFVBFD87" {
provider = "aws.search_staging_assume"
  aliases = ["vp-ppl-qa.capstage.net"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "cap-origin-vp-ppl-qa-s3"
    viewer_protocol_policy = "redirect-to-https"
  }

  logging_config {
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    include_cookies = false
    prefix          = "273213456764/E2ISACMFVBFD87"
  }

  default_root_object = "index.html"
  enabled             = "true"
  http_version        = "http2"
  is_ipv6_enabled     = "true"

  origin {
    #custom_origin_config {
    s3_origin_config {
      #http_port                = "80"
      #https_port               = "443"
      #origin_keepalive_timeout = "5"
      #origin_protocol_policy   = "http-only"
      #origin_read_timeout      = "30"
      #origin_ssl_protocols     = ["TLSv1.2", "TLSv1.1", "TLSv1"]
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }

    #domain_name = "vp-ppl-qa.s3-website-us-east-1.amazonaws.com"
    domain_name = aws_s3_bucket.tfer--vp-002D-ppl-002D-qa.bucket_regional_domain_name
    origin_id   = "cap-origin-vp-ppl-qa-s3"

  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  tags = {
    Environment         =  "staging"
    Product             =  "${var.name}"
    vertical            =   "capterra"
    terraform_managed   =   "true" 
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:273213456764:certificate/4283b61c-37eb-4a55-8978-5621181236c3"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
}


resource "aws_s3_bucket" "tfer--vp-002D-ppl-002D-qa" {
provider = "aws.search_staging_assume"
  arn           = "arn:aws:s3:::vp-ppl-qa"
  bucket        = "vp-ppl-qa"
  force_destroy = "false"

  #grant {
    #permissions = ["READ"]
    #type        = "Group"
    #uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
  #}

  #grant {
    #id          = "eb1b1753d1a6453ba8870d8ef2baae9355003128fe5db406cc015833c520577c"
    #permissions = ["FULL_CONTROL"]
    #type        = "CanonicalUser"
  #}

  hosted_zone_id = "Z3AQBSTGFYJSTF"
  region         = "us-east-1"
  request_payer  = "BucketOwner"

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

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "vp-ppl-qa.s3-website-us-east-1.amazonaws.com"
}


resource "aws_s3_bucket_policy" "tfer--vp-002D-ppl-002D-qa" {
provider = "aws.search_staging_assume"
  bucket = "vp-ppl-qa"

  policy = <<POLICY
{
  "Id": "Policy1584989896464",
  "Statement": [
    {
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-developer",
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer"
        ]
      },
      "Resource": [
        "arn:aws:s3:::vp-ppl-qa",
        "arn:aws:s3:::vp-ppl-qa/*"
      ]
    },
    {
            "Sid": "AllowcloudfronttoS3Access",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::vp-ppl-qa/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#This section contains OAI creation for Cloudfront Distribution. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = "aws.search_staging_assume"
  comment = "OAI for SPA app named- ${var.name}"
}
