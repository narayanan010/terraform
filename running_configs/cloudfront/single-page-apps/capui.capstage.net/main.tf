resource "aws_cloudfront_distribution" "tfer--E3L9SUS5ZIX971" {
provider = "aws.capterra"
  aliases = ["capui.capstage.net"]

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "504"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "502"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "503"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "400"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "405"
    response_code         = "0"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "501"
    response_code         = "0"
  }

  default_cache_behavior {
    allowed_methods = ["PATCH", "GET", "DELETE", "OPTIONS", "HEAD", "PUT", "POST"]
    cached_methods  = ["GET", "OPTIONS", "HEAD"]
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
    target_origin_id       = "S3-capui"
    viewer_protocol_policy = "redirect-to-https"

    #Added for default object rendering for multiple directories via lambda@edge
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = "${aws_lambda_function.lambdaedge.qualified_arn}"
      #lambda_arn   = "arn:aws:lambda:us-east-1:176540105868:function:cap-fn-cf-default-object:1"
      include_body = false
    }

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
      #origin_ssl_protocols     = ["TLSv1", "TLSv1.2", "TLSv1.1"]
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }

    #domain_name = "capui.capstage.net.s3-website-us-east-1.amazonaws.com"
    domain_name = aws_s3_bucket.tfer--capui-002E-capstage-002E-net.bucket_regional_domain_name
    origin_id   = "S3-capui"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

 tags = {
    Environment         =  "prd"
    Product             =  "capui.capstage.net"
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
resource "aws_s3_bucket" "tfer--capui-002E-capstage-002E-net" {
provider = "aws.capterra"
  arn           = "arn:aws:s3:::capui.capstage.net"
  bucket        = "capui.capstage.net"
  force_destroy = "false"

  grant {
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }

  hosted_zone_id = "Z3AQBSTGFYJSTF"

  logging {
    target_bucket = "capterra-cloudtrail"
    target_prefix = "/capui"
  }

  region        = "us-east-1"
  request_payer = "BucketOwner"

  tags = {
    ENVIRONMENT       = "prd"
    product           = "capui"
    terraform_managed = "true"
    vertical          = "capterra"
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


resource "aws_s3_bucket_policy" "tfer--capui-002E-capstage-002E-net" {
provider = "aws.capterra"
  bucket = "capui.capstage.net"

  policy = <<POLICY
{
  "Id": "Policy1537903270126",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::176540105868:role/cap-role-jenkins-ec2-instance-profile",
          "arn:aws:iam::176540105868:role/assume-capterra-power-user",
          "arn:aws:iam::176540105868:role/assume-capterra-admin"
        ]
      },
      "Resource": "arn:aws:s3:::capui.capstage.net",
      "Sid": "Stmt1537903147739"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
            },
      "Resource": "arn:aws:s3:::capui.capstage.net/*",
      "Sid": "Stmt1537903259689"
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