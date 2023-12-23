# This config will:
	##  Create Cloudfront Distribution with:-
			### Origin to vp-frontend-production bucket
			### Origin access identity


#*************************************************************************************************************************************************************#
#                                                                       GLOBAL DATA                                                                           #
#*************************************************************************************************************************************************************#

data "aws_iam_account_alias" "current" {}
data "aws_canonical_user_id" "current_user" {}


#*************************************************************************************************************************************************************#
#                                                               AWS CLOUDFRONT SECTION WITH ALL SETTINGS                                                      #
#*************************************************************************************************************************************************************#

#This section contains the CDN distro (Cloudfront) with all the settings needed.
resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = var.s3_regional_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "This is for hosting for vp-frontend-production"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    prefix          = "${data.aws_caller_identity.current.account_id}/vp-frontend-production"
  }

  aliases = var.cf_alias

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "origin-s3-vp-frontend-production"
    compress = true

    forwarded_values {
      query_string = var.cf_forward_query_string
      headers      = var.cf_headers
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.cf_viewer_protocol_policy
    min_ttl                = var.custom_min_ttl
    default_ttl            = var.custom_default_ttl
    max_ttl                = var.custom_max_ttl

    #Added for default object rendering for multiple directories via lambda@edge
    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = "${aws_lambda_function.lambdaedge.qualified_arn}"
      include_body = false
    }  

  }

  price_class = var.cf_price_class

  restrictions {
      geo_restriction{
          restriction_type = "none"
      }    
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    cloudfront_default_certificate = true
    ssl_support_method  = "sni-only"
    minimum_protocol_version = var.cf_minimum_protocol_version
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  web_acl_id = var.waf_acl_arn
}



#This section contains OAI creation for Cloudfront Distribution. The whole purpose is to limit access to S3 buckets only via Cloudfront (Not Public)
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for app named vp-frontend-production"
}



#####################################This section is added for lambda@edge for default page rendering###############################
# This creates lambda function that appends default object i.e index.html for multiple directories
resource "aws_lambda_function" "lambdaedge" {
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
}

resource "aws_lambda_permission" "alp" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambdaedge.arn}"
  principal     = "events.amazonaws.com"
  statement_id  = "AllowExecution"
}

#This section is for IAM role specification to have bare minimum roles to run lambda properly; trust relationship
resource "aws_iam_role" "air" {
  name = "tf-${var.name}-cloudfront-lambda-role"
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
  name_prefix = "tf-${var.name}-cloudfront-lambda-policy"
  role        = "${aws_iam_role.air.id}"
  policy      = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:aws:logs:${var.modulecaller_source_region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.tf-cfLogGroup.name}:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${var.modulecaller_source_region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.tf-cfLogGroup.name}:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = ["logs:CreateLogGroup"]
    resources = [
      "arn:aws:logs:${var.modulecaller_source_region}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "tf-cfLogGroup" {
  name = "/aws/lambda/tf-${var.name}-cloudfrontmultidir"

  tags = {
    Service = "Cloudfront"
    app = "vp-frontend-prod"
  }
}

resource "aws_cloudwatch_log_stream" "acls-cf" {
  name           = "cf-logstream"
  log_group_name = "${aws_cloudwatch_log_group.tf-cfLogGroup.name}"
}