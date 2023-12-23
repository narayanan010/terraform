output "sec_grp_id" {
  description = "This will provide the created Security Group IDs"
  value       = aws_security_group.sec_grp[*].arn
}

output "sec_grp_arn" {
  value       = aws_security_group.sec_grp[*].arn
  description = "This will provide the created Security Group ARNs"
}
