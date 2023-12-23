output "eks_roles_arn" {
  value       = [for name in local.eks_environments : aws_iam_role.eks_main_roles[name].arn]
  description = "IAM arn roles for EKS"
}
