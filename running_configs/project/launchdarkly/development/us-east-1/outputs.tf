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

output "relay_proxy_sec_grp_id" {
	value       = aws_security_group.ld-relay-proxy-sg.id
	description = "The Security group associated with Launch Darkly Relay Proxy EC2 instances"
}