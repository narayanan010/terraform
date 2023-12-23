output "web_acl_arn" {
  value       = aws_wafv2_web_acl.mainsite-acl-prod-us-west-2.arn
  description = "This will provide the created Web ACL ARN"
}


output "web_acl_capacity" {
  value       = aws_wafv2_web_acl.mainsite-acl-prod-us-west-2.capacity
  description = "This will provide the created Web ACL capacity"
}


output "web_acl_id" {
  value       = aws_wafv2_web_acl.mainsite-acl-prod-us-west-2.id
  description = "This will provide the created Web ACL ID"
}