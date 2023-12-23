#cronjob
output "cronjob_sa_iam_role_arn" {
   description = "ARN of IAM role for cap_rbr_py stage"
   value       = module.iam_assumable_role_cap_rbr_py.iam_role_arn
 }

 output "cronjob_sa_iam_role_name" {
   description = "Name of IAM role for cap_rbr_py stage"
   value       = module.iam_assumable_role_cap_rbr_py.iam_role_name
 }

 output "cronjob_sa_iam_role_path" {
   description = "Path of IAM role for cap_rbr_py stage"
   value       = module.iam_assumable_role_cap_rbr_py.iam_role_path
 }
