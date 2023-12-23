output "dns_hosted_zone_id" {
  value       = module.dns-zones.route53_zone_zone_id.saqa-aws-gartner
  description = "Hosted Zones ID created."
}

output "dns_record" {
  value       = aws_route53_record.mapping-saqa-aws-gartner.name
  description = "record name created."
}