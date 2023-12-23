output "alb_id" {
  value       = module.aws_lb_module.alb_id
  description = "This will provide the created ALB ID"
}

output "alb_arn" {
  value       = module.aws_lb_module.alb_arn
  description = "This will provide the created ALB ARN"
}

output "alb_dns_name" {
  value       = module.aws_lb_module.alb_dns_name
  description = "This will provide the created ALB DNS name"
}

output "http_tcp_listener_arns" {
  value       = module.aws_lb_module.http_tcp_listener_arns
  description = "This will provide the created ALB TCP Listener ARNs"
}

output "http_tcp_listener_ids" {
  value       = module.aws_lb_module.http_tcp_listener_ids
  description = "This will provide the created ALB TCP Listener IDs"
}

output "https_listener_arns" {
  value       = module.aws_lb_module.https_listener_arns
  description = "This will provide the created ALB HTTPS Listener ARNs"
}

output "https_listener_ids" {
  value       = module.aws_lb_module.https_listener_ids
  description = "This will provide the created ALB HTTPS Listener IDs"
}

output "target_group_arns" {
  value       = module.aws_lb_module.target_group_arns
  description = "This will provide the created Target Group ARNs"
}

output "target_group_names" {
  value       = module.aws_lb_module.target_group_names
  description = "This will provide the created Target Group Names"
}

output "target_group_attachments" {
  value       = module.aws_lb_module.target_group_attachments
  description = "This will provide the ARNs of the Target Group Attachment IDs"
}
