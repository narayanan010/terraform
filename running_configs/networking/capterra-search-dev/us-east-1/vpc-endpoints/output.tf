output "interface_elastic_main_dns" {
  value       = module.elastic-vpc-endpoints.interface_vpc_endpoints[0].dns_entry[0].dns_name
  description = "List of Interface VPC Endpoints deployed to this VPC."
}

output "interface_elastic_main_hosted_zone_id" {
  value       = module.elastic-vpc-endpoints.interface_vpc_endpoints[0].dns_entry[0].hosted_zone_id
  description = "List of Interface VPC Endpoints deployed to this VPC."
}

output "elastic_hosted_zone_id" {
  value       = module.dns-zones.route53_zone_zone_id.elastic_cloud
  description = "Hosted Zones ID created."
}

output "elastic_dns_record" {
  value       = aws_route53_record.elastic_cloud.name
  description = "Elastic record name created."
}

output "elastic_endpoint_sg_id" {
  value = aws_security_group.elastic_cloud_endpoint.id
}