output "zookeeper_connect_string" {
  value = aws_msk_cluster.declared_data.zookeeper_connect_string
}


output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.declared_data.bootstrap_brokers_tls
}