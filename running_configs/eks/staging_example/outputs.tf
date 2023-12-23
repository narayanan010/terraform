# EKS Outputs
################################################################

output "eks_info" {
  description = "Kubernetes Cluster Info"
  value       = module.eks_onboarding_staging.eks_info
}
output "eks_namespaces" {
  description = "Get EKS Namespaces"
  value       = module.eks_onboarding_staging.eks_namespaces
}

output "eks_roles" {
  description = "Get EKS Cluster Roles medatadata"
  value       = module.eks_onboarding_staging.eks_roles
}

output "eks_users" {
  description = "Get EKS Cluster user medatada"
  value       = module.eks_onboarding_staging.eks_users
}

output "eks_bindings" {
  description = "Get EKS Cluster Bindings medatada"
  value       = module.eks_onboarding_staging.eks_bindings
}

# IAM Outputs
################################################################
output "iam_roles" {
  description = "Get AWS IAM Roles"
  value       = module.eks_onboarding_staging.iam_roles
}

# Constrains settings
################################################################

output "namespace_mapping" {
  value = module.eks_onboarding_staging.namespace_mapping
}

output "team_mapping" {
  value = module.eks_onboarding_staging.team_mapping
}
