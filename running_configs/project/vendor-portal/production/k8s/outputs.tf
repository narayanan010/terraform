#Vendor Portal
output "vendor_portal_api_sa_iam_role_arn" {
   description = "ARN of IAM role for Vendor Portal Api"
   value       = module.iam_assumable_role_vendor_portal_api.iam_role_arn
 }

 output "vendor_portal_api_sa_iam_role_name" {
   description = "Name of IAM role for Vendor Portal Api"
   value       = module.iam_assumable_role_vendor_portal_api.iam_role_name
 }

 output "vendor_portal_api_sa_iam_role_path" {
   description = "Path of IAM role for Vendor Portal Api"
   value       = module.iam_assumable_role_vendor_portal_api.iam_role_path
 }

output "vendor_portal_workers_sa_iam_role_arn" {
   description = "ARN of IAM role for Vendor Portal Workers"
   value       = module.iam_assumable_role_vendor_portal_workers.iam_role_arn
 }

 output "vendor_portal_workers_sa_iam_role_name" {
   description = "Name of IAM role for Vendor Portal Workers"
   value       = module.iam_assumable_role_vendor_portal_workers.iam_role_name
 }

 output "vendor_portal_workers_sa_iam_role_path" {
   description = "Path of IAM role for Vendor Portal Workers"
   value       = module.iam_assumable_role_vendor_portal_workers.iam_role_path
 }
