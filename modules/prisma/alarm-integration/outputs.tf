output "prisma_alarm_queue_arn" {
  description = "The ARN of the Prisma Alarm Queue"
  value       = aws_sqs_queue.prisma_alarm_queue.arn
}
