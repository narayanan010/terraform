/*output "global_cluster_arn" {
	value = "${aws_rds_global_cluster.main.arn}"
	description = "This will provide the created global cluster ARN"
}

output "global_cluster_id" {
	value = "${aws_rds_global_cluster.main.id}"
	description = "This will provide the created cluster ID"
}

output "db_cluster_arn_primary" {
  value       = "${aws_rds_cluster.primary.db_cluster_arn}"
  description = "ARN of the Primary DB Cluster"
}

output "db_cluster_arn_secondary" {
  value       = "${aws_rds_cluster.secondary.db_cluster_arn}"
  description = "ARN of the Secondary DB Cluster"
}

output "global_cluster_resource_id" {
  value       = "${aws_rds_global_cluster.main.global_cluster_resource_id}"
  description = "global_cluster_resource_id"
}*/