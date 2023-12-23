output "aws_ecr_repository_arn" {
  description = "The ARN of the repository"
  value       = aws_ecr_repository.repo.arn
}

output "aws_ecr_repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.repo.repository_url
}
