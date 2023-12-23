resource "aws_wafv2_web_acl_association" "alb_waf_acl" {
  provider     = aws
  resource_arn = aws_lb.mainsite-alb-prod-us-east-1.arn
  web_acl_arn  = "arn:aws:wafv2:us-east-1:176540105868:regional/webacl/mainsite-acl-prod-us-east-1/71eede4a-5311-4eac-a204-7647265afe62"
}