data "aws_wafv2_web_acl" "crf" {
  name  = var.aws_wafv2_web_acl_name
  scope = "CLOUDFRONT"
}