output "id" {
  description = "List of IDs of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.id}"]
}

output "availability_zone" {
  description = "List of availability zones of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.availability_zone}"]
}

output "key_name" {
  description = "List of key names of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.key_name}"]
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.public_dns}"]
}

output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.public_ip}"]
}

output "network_interface_id" {
  description = "List of IDs of the network interface of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.network_interface_id}"]
}

output "primary_network_interface_id" {
  description = "List of IDs of the primary network interface of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.primary_network_interface_id}"]
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.private_dns}"]
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.private_ip}"]
}

output "vpc_security_group_ids" {
  description = "List of associated security groups of instances, if running in non-default VPC"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.vpc_security_group_ids}"]
}

output "subnet_id" {
  description = "List of IDs of VPC subnets of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.subnet_id}"]
}

output "credit_specification" {
  description = "List of credit specification of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.credit_specification}"]
}

output "tags" {
  description = "List of tags of instances"
  value       = ["${aws_instance.tfer--i-002D-0903dfc7c409568fa_Central-0020-Deployment.tags}"]
}

output "sg-id" {
  description = "Security group id"
  value       = ["${aws_security_group.sg-cds.id}"]
}