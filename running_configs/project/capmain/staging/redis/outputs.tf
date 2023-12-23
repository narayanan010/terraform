output "subnet_group_name" {
	value = aws_elasticache_subnet_group.tf-subnetgroup-capmain-staging-redis.name
 	description = "Name of subnet group created"
}

output "replication_group_id" {
	value = aws_elasticache_replication_group.capmain_staging_redis.id
 	description = "The ID of the ElastiCache Replication Group."
}

output "configuration_endpoint_address" {
	value = aws_elasticache_replication_group.capmain_staging_redis.configuration_endpoint_address
 	description = "The address of the replication group configuration endpoint when cluster mode is enabled."
}

output "primary_endpoint_address" {
	value = aws_elasticache_replication_group.capmain_staging_redis.primary_endpoint_address
 	description = "(Redis only) The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
}

output "member_clusters" {
  value = aws_elasticache_replication_group.capmain_staging_redis.member_clusters
  description = "The identifiers of all the nodes that are part of this replication group."
}

output "redis_password_arn" {
  value = aws_ssm_parameter.capmain-staging-ssm-redis-random-name.arn
  description = "Redis password ARN vault on SSM Parameter store"
}