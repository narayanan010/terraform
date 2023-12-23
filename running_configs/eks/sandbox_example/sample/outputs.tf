# EKS Outputs
################################################################

output "eks_info" {
  description = "Kubernetes Cluster Info"
  value       = module.eks_onboarding_sandbox.eks_info
}
output "eks_namespaces" {
  description = "Get EKS Namespaces"
  value       = module.eks_onboarding_sandbox.eks_namespaces
}

output "eks_roles" {
  description = "Get EKS Cluster Roles medatadata"
  value       = module.eks_onboarding_sandbox.eks_roles
}

output "eks_users" {
  description = "Get EKS Cluster user medatada"
  value       = module.eks_onboarding_sandbox.eks_users
}

output "eks_bindings" {
  description = "Get EKS Cluster Bindings medatada"
  value       = module.eks_onboarding_sandbox.eks_bindings
}


# IAM Outputs
################################################################
output "iam_roles" {
  description = "Get AWS IAM Roles"
  value       = module.eks_onboarding_sandbox.iam_roles
}

output "iam_groups" {
  description = "Get AWS IAM Groups"
  value       = module.eks_onboarding_sandbox.iam_groups
}


# eksctl Outputs
################################################################
output "eksctl_basic_user" {
  value = module.eks_onboarding_sandbox.eks_role_basic_user_arn
}

output "eksctl_admin_user" {
  value = module.eks_onboarding_sandbox.eks_role_admin_user_arn
}

output "eksctl_ro_user" {
  value = module.eks_onboarding_sandbox.eks_role_read_only_user_arn
}