output "main_service_record" {
  value       = aws_route53_record.main_service_record
  description = "Service record name created."
}

output "cm_service_record" {
  value       = aws_route53_record.cm_service_record
  description = "Service record name created."
}
