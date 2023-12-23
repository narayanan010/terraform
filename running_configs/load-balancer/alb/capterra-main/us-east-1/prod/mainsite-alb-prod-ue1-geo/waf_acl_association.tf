resource "aws_wafv2_web_acl_association" "alb_waf_acl" {
  provider     = aws
  resource_arn = aws_lb.mainsite-alb-prod-ue1-geo.arn
  web_acl_arn  = var.waf_arn
}