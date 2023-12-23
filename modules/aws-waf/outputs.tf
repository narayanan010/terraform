output "web_acl_arn" {
  value       = aws_wafv2_web_acl.waf-acl.arn
  description = "This will provide the created Web ACL ARN"
}


output "web_acl_capacity" {
  value       = aws_wafv2_web_acl.waf-acl.capacity
  description = "This will provide the created Web ACL capacity"
}


output "web_acl_id" {
  value       = aws_wafv2_web_acl.waf-acl.id
  description = "This will provide the created Web ACL ID"
}