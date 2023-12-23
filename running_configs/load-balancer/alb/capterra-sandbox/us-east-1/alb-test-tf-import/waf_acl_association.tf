resource "aws_wafv2_web_acl_association" "alb_waf_acl" {
  provider     = aws
  resource_arn = aws_lb.alb-test-tf-import.arn
  web_acl_arn  = "arn:aws:wafv2:us-east-1:944864126557:regional/webacl/FMManagedWebACLV2-AWS_FMS_ShieldAdvancedRule-1655501154300/6cdc4918-2be9-483e-bcdf-78c0a558fc0c"
}