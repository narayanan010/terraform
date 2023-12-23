#Organizations
output "organizations_api_sa_iam_role_arn" {
   description = "ARN of IAM role for Organizations Api"
   value       = module.iam_assumable_role_organizations_api.iam_role_arn
 }

 output "organizations_api_sa_iam_role_name" {
   description = "Name of IAM role for Organizations Api"
   value       = module.iam_assumable_role_organizations_api.iam_role_name
 }

 output "organizations_api_sa_iam_role_path" {
   description = "Path of IAM role for Organizations Api"
   value       = module.iam_assumable_role_organizations_api.iam_role_path
 }

output "organizations_consumers_sa_iam_role_arn" {
   description = "ARN of IAM role for Organizations Consumers"
   value       = module.iam_assumable_role_organizations_consumers.iam_role_arn
 }

 output "organizations_consumers_sa_iam_role_name" {
   description = "Name of IAM role for Organizations Consumers"
   value       = module.iam_assumable_role_organizations_consumers.iam_role_name
 }

 output "organizations_consumers_sa_iam_role_path" {
   description = "Path of IAM role for Organizations Consumers"
   value       = module.iam_assumable_role_organizations_consumers.iam_role_path
 }

output "organizations_workers_sa_iam_role_arn" {
   description = "ARN of IAM role for Organizations Workers"
   value       = module.iam_assumable_role_organizations_workers.iam_role_arn
 }

 output "organizations_workers_sa_iam_role_name" {
   description = "Name of IAM role for Organizations Workers"
   value       = module.iam_assumable_role_organizations_workers.iam_role_name
 }

 output "organizations_workers_sa_iam_role_path" {
   description = "Path of IAM role for Organizations Workers"
   value       = module.iam_assumable_role_organizations_workers.iam_role_path
 }
