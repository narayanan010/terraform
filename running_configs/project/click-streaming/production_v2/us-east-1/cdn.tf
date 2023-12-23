data "aws_acm_certificate" "clickstream-cert" {
  domain   = "clicks.capterra.com"
  statuses = ["ISSUED"]
}

# module "click_waf" {
#   source = "git::ssh://git@github.com/capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.1"

#   web_acl_name  = "clickstream-prod"
#   web_acl_scope = "CLOUDFRONT"
#   vertical      = "capterra"
#   stage         = var.stage

#   waf_logging_enabled                 = true
#   waf_logging_filter_enabled          = true
#   waf_logging_filter_default_behavior = "DROP"
#   waf_logging_filters = [
#     { behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{ type = "action_condition", effect = "BLOCK" }] }
#   ]

#   custom_path_size_checker_action_list = [
#     { uri_path = "/external_click/test-click/", uri_path_constraint = "STARTS_WITH", size = 0, size_comparison_operator = "GE", action = "allow", priority = 1 },
#   ]

#   # Nginix rule
#   nginx_server_list_rule_priority       = 2
#   nginx_server_list_rule_status         = "count"
#   nginx_servers_ip_list_address_version = "IPV4"
#   nginx_servers_ip_list_addresses = ["52.13.209.160/32", "34.205.192.229/32", "3.233.207.165/32",
#     "52.11.75.34/32", "35.143.224.66/32", "35.172.62.29/32",
#     "34.234.249.188/32", "35.174.34.104/32", "34.207.38.254/32",
#   "52.39.77.81/32"]

#   # AWS KNOWN BAD INPUTS rule set
#   aws_managed_rules_known_bad_inputs_set_enabled  = true
#   aws_managed_rules_known_bad_inputs_set_priority = 3

#   # AWS IP reputation list
#   aws_managed_rules_ip_reputation_list_enabled  = true
#   aws_managed_rules_ip_reputation_list_priority = 4

#   # AWS CORE rule set
#   aws_managed_rules_common_rule_set_enabled  = true
#   aws_managed_rules_common_rule_set_priority = 5

#   # AWS Anonymous rule set
#   aws_managed_rules_ip_anonymous_list_enabled  = true
#   aws_managed_rules_ip_anonymous_list_priority = 6

#   providers = {
#     aws.primary = aws
#   }
# }

resource "aws_cloudfront_distribution" "clickstream" {
  origin {
    domain_name = "st8srbsy72.execute-api.us-east-1.amazonaws.com"
    origin_id   = "clicks.capterra.com"
    origin_path = "/prod"

    custom_header {
      name  = "original_host"
      value = "clicks.capterra.com"
    }

    custom_origin_config {
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2"]
      http_port              = 80
      https_port             = 443
    }
  }

  logging_config {
    include_cookies = true
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    # NB: Update this if for some reason the distribution needs to be changed
    prefix = "296947561675/E2Y9ZN4ETNHYKU/"
  }

  enabled = true
  # We've seen some IPv6 issues in staging, so disable for the time being
  is_ipv6_enabled     = false
  comment             = "Clickstream production"
  default_root_object = ""

  aliases = ["clicks.capterra.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "clicks.capterra.com"

    # forwarded_values {
    #   query_string = true
    #   headers      = ["Monitoring-System-Click", "Nginx_GeoIp_Country_Code"]

    #   cookies {
    #     forward = "all"
    #   }
    # }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true

    cache_policy_id          = "fef4c93e-4044-4e46-a6bf-f783140bfe38"
    origin_request_policy_id = "7028827e-3694-46f7-97fb-5d6e5d08b8e8"
  }


  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.clickstream-cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
