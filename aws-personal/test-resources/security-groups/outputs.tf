output "sec_grp_id" {
  description = "This will provide the created Security Group IDs"
  value       = aws_security_group.allow_tls.id
}

output "sec_grp_arn" {
  description = "This will provide the created Security Group ARNs"
  value       = aws_security_group.allow_tls.arn
}