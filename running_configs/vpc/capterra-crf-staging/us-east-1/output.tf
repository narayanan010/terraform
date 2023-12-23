output "igw_id" {
  value       = "${module.aws_vpc_mod.igw_id}"
  description = "The ID of the Internet Gateway"
}

output "vpc_id" {
  value       = "${module.aws_vpc_mod.vpc_id}"
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = "${module.aws_vpc_mod.vpc_cidr_block}"
  description = "The CIDR block of the VPC"
}

output "nacl_private_id" {
  value       = "${module.aws_vpc_mod.nacl_private_id}"
  description = "The ID of the NACL associated with Private Subnets"
}

output "VPC_S3Endpoint_id" {
  value       = "${module.aws_vpc_mod.VPC_S3Endpoint_id}"
  description = "The ID of VPCEndpoint created and asssociated to VPC Main RTB and RTBs Subnets"
}
