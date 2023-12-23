output "web_acl_arn" {
   value       = module.aws_waf_module.web_acl_arn
   description = "This will provide the created Web ACL ARN"
 }


 output "web_acl_capacity" {
   value       = module.aws_waf_module.web_acl_capacity
   description = "This will provide the created Web ACL capacity"
 }


 output "web_acl_id" {
   value       = module.aws_waf_module.web_acl_id
   description = "This will provide the created Web ACL ID"
 }