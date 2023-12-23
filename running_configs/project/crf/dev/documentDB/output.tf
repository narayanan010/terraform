output "documentDB_arn" {
	value = module.aws_documentDB_module.documentDB_arn
	description = "This will provide the created cluster ARN"
}

output "documentDB_id" {
	value = module.aws_documentDB_module.documentDB_id
	description = "This will provide the created cluster ID"
}

output "master_username" {
  value       = module.aws_documentDB_module.master_username
  description = "Username for the master DB user"
}

output "cluster_name" {
  value       = module.aws_documentDB_module.cluster_name
  description = "Cluster Identifier"
}

output "endpoint" {
  value       = module.aws_documentDB_module.endpoint
  description = "Endpoint of the DocumentDB cluster"
}