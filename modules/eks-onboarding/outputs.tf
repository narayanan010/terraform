# EKS Outputs
################################################################
output "eks_info" {
  description = "Kubernetes Cluster Info in JSON format"
  value       = { "eks_info" : { "arn" : "${data.aws_eks_cluster.cluster.arn}", "endpoint" : "${data.aws_eks_cluster.cluster.endpoint}", "id" : "${data.aws_eks_cluster.cluster.id}", "platform_version" : "${data.aws_eks_cluster.cluster.platform_version}", "role_arn" : "${data.aws_eks_cluster.cluster.role_arn}", "version" : "${data.aws_eks_cluster.cluster.version}" } }
}

output "eks_namespaces" {
  description = "Get EKS Namespaces"
  value       = data.kubernetes_all_namespaces.allns.namespaces
}

output "eks_roles" {
  description = "Get EKS Cluster Roles medatadata"
  value       = concat([kubernetes_role.admin_roles.metadata[0].name], [kubernetes_role.readonly_roles.metadata[0].name], [kubernetes_role.basicuser_roles.metadata[0].name], [kubernetes_role.deployer_roles.metadata[0].name])
}

output "eks_role_deployer_user_arn" {
  description = "Get EKS role deployer_user arn"
  value       = aws_iam_role.deployer_user_cluster_role.arn
}

output "eks_users" {
  description = "Get EKS Cluster user medatada"
  value       = concat([local.k8s_user_admin], [local.k8s_user_readonly], [local.k8s_user_basicuser], [local.k8s_user_deployer])
}

output "eks_bindings" {
  description = "Get EKS Cluster Bindings medatada"
  value       = concat([kubernetes_role_binding.admin_role_binding.metadata[0].name], [kubernetes_role_binding.readonly_role_binding.metadata[0].name], [kubernetes_role_binding.basicuser_role_binding.metadata[0].name], [kubernetes_role_binding.deployer_role_binding.metadata[0].name])
}


# IAM Outputs
################################################################
output "iam_roles" {
  description = "Get AWS IAM Roles"
  value       = concat([aws_iam_role.deployer_user_cluster_role.arn])
}

# Constrains settings
################################################################

output "team_mapping" {
  description = "Service team mapping configured in JSON format"
  value       = { "team_mapping" : { "namespace" : "${var.namespace}", "stage" : "${var.stage}", "ecr_repository_tag_team" : "${local.ecr_repository_tag_team}", "github_repository" : [for repositories in toset(local.github_repository) : "${repositories}"], "eks_cluster" : { "name" : "${var.eks_name}", "kms" : "${local.kms_clusters}", "hostedzone" : "${local.hostedzone}" } } }
}

output "namespace_mapping" {
  description = "Configuration parameters Payload"
  value       = var.namespace_mapping
}
