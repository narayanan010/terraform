output "web_acl_lb_arn" {
  value       = module.aws_waf_module.web_acl_arn
  description = "This will provide the created Web ACL ARN"
}

output "web_acl_lb_capacity" {
  value       = module.aws_waf_module.web_acl_capacity
  description = "This will provide the created Web ACL capacity"
}

output "web_acl_lb_id" {
  value       = module.aws_waf_module.web_acl_id
  description = "This will provide the created Web ACL ID"
}

output "web_acl_api_arn" {
  value       = module.aws_waf_api_gateway.web_acl_arn
  description = "This will provide the created Web ACL ARN"
}

output "web_acl_api_capacity" {
  value       = module.aws_waf_api_gateway.web_acl_capacity
  description = "This will provide the created Web ACL capacity"
}

output "web_acl_api_id" {
  value       = module.aws_waf_api_gateway.web_acl_id
  description = "This will provide the created Web ACL ID"
}
