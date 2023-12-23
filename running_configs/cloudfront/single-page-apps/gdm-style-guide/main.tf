resource "aws_cloudfront_distribution" "tfer--E2N5WHOMLSGI88" {
provider = "aws.capterra"
  aliases = ["gdm-style-guide.capstage.net"]
  comment = "GDM Style Guide Cloudfront Distribution"

  default_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "true"
    default_ttl     = "86400"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "cap-origin-s3-gdm-style-guide"
    viewer_protocol_policy = "allow-all"

    #Added for default object rendering for multiple directories via lambda@edge
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = "${aws_lambda_function.lambdaedge.qualified_arn}"
      include_body = false
    }

  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  origin {
    domain_name = "gdm-style-guide.capstage.net.s3.amazonaws.com"
    origin_id   = "cap-origin-s3-gdm-style-guide"
    #Added to restrict access via OAI
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  tags = {
    Environment         =  "prd"
    Product             =  "${var.name}"
    vertical            =   "capterra"
    terraform_managed   =   "true" 
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:176540105868:certificate/3ef8a4cd-b4cf-482e-bb70-2c313a7c63fc"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = "53f9a7a5-ec14-4523-b8e5-c4d030163b2d"
}

#####################################This section is added for lambda@edge for default page rendering###############################
# This creates lambda function that appends default object i.e index.html for multiple directories
resource "aws_lambda_function" "lambdaedge" {
provider = "aws.capterra"
  filename      = "lambdaedge-cap-fn-cf-default-object.zip"
  function_name = "tf-${var.name}-cloudfrontmultidir"
  role          = "${aws_iam_role.air.arn}"
  handler       = "index.handler"
  description   = "lambda function for ${var.name} for rendering default object when multiple dir, basically url changes"
  publish       = "true"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #source_code_hash = "${base64sha256(file("lambdaedge-cap-fn-cf-default-object.zip"))}"
  source_code_hash = "${filebase64sha256("lambdaedge-cap-fn-cf-default-object.zip")}"

  runtime = "${var.runtime_lambda}"
  tags = {
        terraform_managed = "true"      
    }
}

resource "aws_lambda_permission" "alp" {
provider = "aws.capterra"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambdaedge.arn}"
  principal     = "events.amazonaws.com"
  statement_id  = "AllowExecution"
}

#This section is for IAM role specification to have bare minimum roles to run lambda properly; trust relationship
resource "aws_iam_role" "air" {
provider = "aws.capterra"
  name = "tf-${var.name}-cloudfront-lambda-role"
  tags = {
    terraform_managed = "true"
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com",
        "Service": "edgelambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "policy" {
provider = "aws.capterra"
  name_prefix = "tf-${var.name}-cloudfront-lambda-policy"
  role        = "${aws_iam_role.air.id}"
  policy      = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "policy" {
provider = "aws.capterra"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.tf-cfLogGroup.name}:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${aws_cloudwatch_log_group.tf-cfLogGroup.name}:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = ["logs:CreateLogGroup"]
    resources = [
      "arn:aws:logs:${var.region}:${var.aws_account_id}:*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "tf-cfLogGroup" {
provider = "aws.capterra"
  name = "/aws/lambda/tf-${var.name}-cloudfrontmultidir"

  tags = {
    terraform_managed = "true"
    Service = "Cloudfront"
  }
}

resource "aws_cloudwatch_log_stream" "acls-cf" {
provider = "aws.capterra"
  name           = "cf-logstream"
  log_group_name = "${aws_cloudwatch_log_group.tf-cfLogGroup.name}"
}

#####################################This section ends here###############################

#Bucket and Policy
resource "aws_s3_bucket" "tfer--gdm-002D-style-002D-guide-002E-capstage-002E-net" {
provider = "aws.capterra"
  arn           = "arn:aws:s3:::gdm-style-guide.capstage.net"
  bucket        = "gdm-style-guide.capstage.net"
  force_destroy = "false"

  grant {
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

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
    ENVIRONMENT       = "prd"
    product           = "gdm_style_guide"
    terraform_managed = "true"
    vertical          = "gdm"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  website_domain   = "s3-website-us-east-1.amazonaws.com"
  website_endpoint = "gdm-style-guide.capstage.net.s3-website-us-east-1.amazonaws.com"
}


resource "aws_s3_bucket_policy" "tfer--gdm-002D-style-002D-guide-002E-capstage-002E-net" {
provider = "aws.capterra"
  bucket = "gdm-style-guide.capstage.net"

  policy = <<POLICY
{
  "Id": "Policy1537903270126",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::176540105868:role/assume-capterra-admin",
          "arn:aws:iam::176540105868:role/assume-capterra-power-user",
          "arn:aws:iam::176540105868:role/cap-role-jenkins-ec2-instance-profile"
        ]
      },
      "Resource": [
        "arn:aws:s3:::gdm-style-guide.capstage.net/*",
        "arn:aws:s3:::gdm-style-guide.capstage.net"
      ],
      "Sid": "Stmt1537903147739"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
            },
      "Resource": "arn:aws:s3:::gdm-style-guide.capstage.net/*",
      "Sid": "AllowcloudfronttoS3Access"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#This section contains OAI creation for Cloudfront Distribution. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = "aws.capterra"
  comment = "OAI for SPA app named- ${var.name}"
}