output "zookeeper_connect_string" {
  value = aws_msk_cluster.click_streaming.zookeeper_connect_string
}


output "zookeeper_connect_string_tls" {
  value = aws_msk_cluster.click_streaming.zookeeper_connect_string_tls
}


output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.click_streaming.bootstrap_brokers_tls
}

output "bootstrap_brokers_iam" {
  description = "IAM connection host:port pairs"
  value       = aws_msk_cluster.click_streaming.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_scram" {
  description = "IAM connection host:port pairs"
  value       = aws_msk_cluster.click_streaming.bootstrap_brokers_sasl_scram
}

output "ec2_instance_id2" {
  description = "Description: The ID of the instance"
  value       = [for name in local.ec2_suffix : module.datadog-instance[name].id]
}

output "ec2_private_ip" {
  description = "Description: The private_ip of the instance"
  value       = [for name in local.ec2_suffix : module.datadog-instance[name].private_ip]
}

output "sg_click_streaming_msk_id" {
  description = "Security Group ID for click-streaming-msk"
  value       = aws_security_group.click_streaming_msk.id
}
output "sg_click_streaming_msk_ec2_id" {
  description = "Security Group ID for click_streaming_msk_ec2"
  value       = aws_security_group.click_streaming_msk_ec2.id
}

output "sg_click_streaming_lambda_id" {
  description = "Security Group ID for click_streaming_lambda"
  value       = aws_security_group.click_streaming_lambda.id
}

output "secretsmanager_secret_click_streaming_arn" {
  description = "Secrets Manager secret metadata arn"
  value       = aws_secretsmanager_secret.msk_sasl_scram.arn
} 