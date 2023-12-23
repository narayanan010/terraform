output "waf_logs_s3_bucket_name" {
  value       = aws_s3_bucket.waf_logs.id
  description = "Name of s3 bucket used for WAF Logs"
}

output "waf_logs_notification_sqs_arn" {
  value       = aws_sqs_queue.logs_notification.arn
  description = "ARN of sqs used for notify presence of WAF Logs"
}

output "waf_logs_notification_sqs_url" {
  value       = aws_sqs_queue.logs_notification.url
  description = "URL of sqs used for notify presence of WAF Logs"
}

output "scalyr_iam_role_arn" {
  value       = aws_iam_role.scalyr_logs_ingester.arn
  description = "ARN of iam role used by Scalyr"
}

output "scalyr_monitor" {
  value       =   [{
    type: "s3Bucket",
    region: "${var.region}",
    roleToAssume: "${aws_iam_role.scalyr_logs_ingester.arn}",
    queueUrl: "${aws_sqs_queue.logs_notification.url}"
    fileFormat: "text_gzip",
    hostname: "Up to you",
    parser: "WAFLogsCW"
  }]
  description = "Scalyr monitor to be added in https://app.scalyr.com/monitors"
}
