#output "cache_nodes" {
#  value = "${module.aws_redis_module.cache_nodes}"
#  description = "List of node objects including id, address, port and availability_zone. Referenceable e.g. as aws_elasticache_cluster.ec_cluster.cache_nodes.0.address"
#}

output "subnet_group_name" {
  value       = module.aws_redis_module.subnet_group_name
  description = "Name of subnet group created"
}

output "replication_group_id" {
  value       = module.aws_redis_module.replication_group_id
  description = "The ID of the ElastiCache Replication Group."
}

output "configuration_endpoint_address" {
  value       = module.aws_redis_module.configuration_endpoint_address
  description = "The address of the replication group configuration endpoint when cluster mode is enabled."
}

output "primary_endpoint_address" {
  value       = module.aws_redis_module.primary_endpoint_address
  description = "(Redis only) The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
}

output "member_clusters" {
  value       = module.aws_redis_module.member_clusters
  description = "The identifiers of all the nodes that are part of this replication group."
}

output "graphql_stage_sa_iam_role_arn" {
  description = "ARN of IAM role for cronjob"
  value       = module.iam_assumable_role_graphql_stage.iam_role_arn
}

output "graphql_stage_sa_iam_role_name" {
  description = "Name of IAM role for cronjob"
  value       = module.iam_assumable_role_graphql_stage.iam_role_name
}

output "graphql_stage_sa_iam_role_path" {
  description = "Path of IAM role for cronjob"
  value       = module.iam_assumable_role_graphql_stage.iam_role_path
}

output "secrets_graphql_arn" {
  value       = aws_secretsmanager_secret.secrets_graphql.arn
  description = "Secrets manager for graphql application"
}