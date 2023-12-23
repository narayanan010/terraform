output "ec2_instance_id2" {
  description = "Description: The ID of the instance"
  value       = [for name in local.ec2_suffix : module.deployment_server[name].id]
}

output "ec2_private_ip" {
  description = "Description: The private_ip of the instance"
  value       = [for name in local.ec2_suffix : module.deployment_server[name].private_ip]
}