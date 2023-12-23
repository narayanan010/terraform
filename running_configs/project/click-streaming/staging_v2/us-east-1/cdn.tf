data "aws_acm_certificate" "clickstream-cert" {
  domain   = "clicks.capstage.net"
  statuses = ["ISSUED"]
}


# module "click_waf" {
#   source = "git::ssh://git@github.com/capterra/terraform.git//modules/aws-waf?ref=aws-waf-v1.0.0"

#   web_acl_name  = "clickstream-stage"
#   web_acl_scope = "CLOUDFRONT"
#   vertical      = "capterra"
#   stage         = var.stage

#   waf_dd_alerts_to                    = "@alert_click_streaming_stg-slack"
#   waf_logging_enabled                 = true
#   waf_logging_filter_enabled          = true
#   waf_logging_filter_default_behavior = "DROP"
#   waf_logging_filters = [
#     { behavior = "KEEP", requirement = "MEETS_ALL", conditions = [{ type = "action_condition", effect = "BLOCK" }] }
#   ]

#   custom_path_checker_action_list = [
#     { uri_path = "/external_click/test-click/", uri_path_constraint = "STARTS_WITH", action = "allow", priority = 1 },
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
    domain_name = "m0c9dy5q6l.execute-api.us-east-1.amazonaws.com"
    origin_id   = "clicks.capstage.net"
    origin_path = "/staging"

    connection_attempts = 3
    connection_timeout  = 10
    custom_origin_config {
      origin_protocol_policy   = "https-only"
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
      http_port                = 80
      https_port               = 443

    }

    custom_header {
      name  = "original_host"
      value = "clicks.capstage.net"
    }
  }

  logging_config {
    include_cookies = true
    bucket          = "capterra-cloudfront-logs.s3.amazonaws.com"
    # NB: Update this if for some reason the distribution needs to be changed
    prefix = "273213456764/EDIN03EWVM6B1/"
  }

  enabled = true
  # We've seen some IPv6 issues in staging, so disable for the time being
  is_ipv6_enabled     = false
  comment             = "Clickstream staging"
  default_root_object = ""

  aliases = ["clicks.capstage.net"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "clicks.capstage.net"

    cache_policy_id          = "7237d465-9732-447a-93bc-ac50a3204d1a"
    origin_request_policy_id = "baba25f7-5ded-462f-b59e-7dd00437059e"
    realtime_log_config_arn  = "arn:aws:cloudfront::273213456764:realtime-log-config/click-streaming-staging"

    # forwarded_values {
    #   query_string = true
    #   headers      = ["Nginx_GeoIp_Country_Code"]

    #   cookies {
    #     forward = "all"
    #   }
    # }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true

    # lambda_function_association {
    #   event_type   = "viewer-request"
    #   lambda_arn   = aws_lambda_function.cloudfront_pxEnforcer.qualified_arn
    #   include_body = true
    # }
  }


  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  #web_acl_id = module.click_waf.web_acl_arn
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.clickstream-cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
