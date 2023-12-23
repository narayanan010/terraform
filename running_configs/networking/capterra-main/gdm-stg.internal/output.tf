output "dns_hosted_zone_id" {
  value       = module.dns-zones.route53_zone_zone_id.gdmstg_internal
  description = "Hosted Zones ID created."
}

output "dns_record" {
  value       = aws_route53_record.bxapi-db-test1.name
  description = "record name created."
}