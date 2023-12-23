output "alb_id" {
  value       = aws_alb.nlb.*.id
  description = "This will provide the created ALB ID"
}

output "alb_arn" {
  value       = aws_alb.nlb.*.arn
  description = "This will provide the created ALB ARN"
}

output "alb_dns_name" {
  value       = aws_alb.nlb.*.dns_name
  description = "This will provide the created ALB DNS Name"
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = aws_alb_listener.frontend_http_tcp.*.arn
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = aws_alb_listener.frontend_http_tcp.*.id
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = aws_alb_listener.frontend_https.*.arn
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = aws_alb_listener.frontend_https.*.id
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_alb_target_group.nlb-tg.*.arn
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = aws_alb_target_group.nlb-tg.*.name
}

output "target_group_attachments" {
  description = "ARNs of the target group attachment IDs."
  value = {
    for k, v in aws_alb_target_group_attachment.this : k => v.id
  }
}