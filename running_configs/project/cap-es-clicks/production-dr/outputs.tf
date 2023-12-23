output "ssm-document-arn" {
   description = "ARN of SSM Document"
   value       = aws_ssm_document.this.arn
}
