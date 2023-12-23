#cronjob
output "cronjob_sa_iam_role_arn" {
   description = "ARN of IAM role for cronjob"
   value       = module.iam_assumable_role_cronjob.iam_role_arn
 }

 output "cronjob_sa_iam_role_name" {
   description = "Name of IAM role for cronjob"
   value       = module.iam_assumable_role_cronjob.iam_role_name
 }

 output "cronjob_sa_iam_role_path" {
   description = "Path of IAM role for cronjob"
   value       = module.iam_assumable_role_cronjob.iam_role_path
 }
