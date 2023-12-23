resource "aws_wafv2_web_acl_association" "alb_waf_acl" {
  provider     = aws
  resource_arn = aws_lb.mainsite-alb-staging-ue1.arn
  web_acl_arn  = "arn:aws:wafv2:us-east-1:176540105868:regional/webacl/mainsite-acl-staging-ue1/da115c14-ae34-44d4-b073-01b824a02d9b"
}