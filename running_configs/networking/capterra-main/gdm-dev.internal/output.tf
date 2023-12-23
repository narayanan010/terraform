output "dns_hosted_zone_id" {
  value       = module.dns-zones.route53_zone_zone_id.gdmdev_internal
  description = "Hosted Zones ID created."
}