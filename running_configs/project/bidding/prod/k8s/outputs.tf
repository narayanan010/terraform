#Bidding
output "bidding_api_sa_iam_role_arn" {
   description = "ARN of IAM role for Bidding Api"
   value       = module.iam_assumable_role_bidding_api.iam_role_arn
 }

 output "bidding_api_sa_iam_role_name" {
   description = "Name of IAM role for Bidding Api"
   value       = module.iam_assumable_role_bidding_api.iam_role_name
 }

 output "bidding_api_sa_iam_role_path" {
   description = "Path of IAM role for Bidding Api"
   value       = module.iam_assumable_role_bidding_api.iam_role_path
 }

output "bidding_consumers_sa_iam_role_arn" {
   description = "ARN of IAM role for Bidding Cronjob"
   value       = module.iam_assumable_role_bidding_consumers.iam_role_arn
 }

 output "bidding_consumers_sa_iam_role_name" {
   description = "Name of IAM role for Bidding Cronjob"
   value       = module.iam_assumable_role_bidding_consumers.iam_role_name
 }

 output "bidding_consumers_sa_iam_role_path" {
   description = "Path of IAM role for Bidding Cronjob"
   value       = module.iam_assumable_role_bidding_consumers.iam_role_path
 }

output "bidding_workers_sa_iam_role_arn" {
   description = "ARN of IAM role for Bidding Workers"
   value       = module.iam_assumable_role_bidding_workers.iam_role_arn
 }

 output "bidding_workers_sa_iam_role_name" {
   description = "Name of IAM role for Bidding Workers"
   value       = module.iam_assumable_role_bidding_workers.iam_role_name
 }

 output "bidding_workers_sa_iam_role_path" {
   description = "Path of IAM role for Bidding Workers"
   value       = module.iam_assumable_role_bidding_workers.iam_role_path
 }
