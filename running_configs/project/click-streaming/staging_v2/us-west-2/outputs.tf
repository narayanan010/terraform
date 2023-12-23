# MSK brokers
output "zookeeper_connect_string" {
  value = aws_msk_cluster.click_streaming_dr.zookeeper_connect_string
}


output "zookeeper_connect_string_tls" {
  value = aws_msk_cluster.click_streaming_dr.zookeeper_connect_string_tls
}


output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.click_streaming_dr.bootstrap_brokers_tls
}

output "bootstrap_brokers_iam" {
  description = "IAM connection host:port pairs"
  value       = aws_msk_cluster.click_streaming_dr.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_scram" {
  description = "IAM connection host:port pairs"
  value       = aws_msk_cluster.click_streaming_dr.bootstrap_brokers_sasl_scram
}

# MSK config
output "secretsmanager_secret_click_streaming_arn" {
  description = "Secrets Manager secret metadata arn"
  value       = aws_secretsmanager_secret.msk_sasl_scram.arn
}

output "msk_click_streaming_arn" {
  description = "Main MSK resource arn"
  value       = concat(["${aws_msk_cluster.click_streaming_dr.arn}", "${aws_msk_cluster.click_streaming_dr.current_version}"])
} 