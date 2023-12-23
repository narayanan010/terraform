output "documentDB_arn" {
	value = "${aws_docdb_cluster.docdb.arn}"
	description = "This will provide the created cluster ARN"
}

output "documentDB_id" {
	value = "${aws_docdb_cluster.docdb.id}"
	description = "This will provide the created cluster ID"
}

output "master_username" {
  value       = "${aws_docdb_cluster.docdb.master_username}"
  description = "Username for the master DB user"
}

output "cluster_name" {
  value       = "${aws_docdb_cluster.docdb.cluster_identifier}"
  description = "Cluster Identifier"
}

output "endpoint" {
  value       = "${aws_docdb_cluster.docdb.endpoint}"
  description = "Endpoint of the DocumentDB cluster"
}