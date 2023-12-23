output "sec_grp_id" {
  description = "This will provide the created Security Group IDs"
  value       = module.aws_sec_grp_module.sec_grp_id
}

output "sec_grp_arn" {
  description = "This will provide the created Security Group ARNs"
  value       = module.aws_sec_grp_module.sec_grp_arn
}

output "sec_grp2_id" {
  description = "This will provide the created Security Group IDs"
  value       = module.aws_sec_grp2_module.sec_grp_id
}

output "sec_grp2_arn" {
  description = "This will provide the created Security Group ARNs"
  value       = module.aws_sec_grp2_module.sec_grp_arn
}