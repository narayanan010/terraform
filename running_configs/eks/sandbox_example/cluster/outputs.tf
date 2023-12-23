

# VPC Outputs
################################################################
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_flow_log_id" {
  value = module.vpc.vpc_flow_log_id
}

output "vpc_flow_log_cloudwatch_arn" {
  value = module.vpc.vpc_flow_log_cloudwatch_iam_role_arn
}

output "vpc_private_subnets_ids" {
  value = module.vpc.private_subnets
}

output "vpc_public_subnets_ids" {
  value = module.vpc.private_subnets
}


# EKS Outputs
################################################################

output "eks_cloudwatch_arn" {
  value = module.eks.cloudwatch_log_group_arn
}

output "eks_cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "eks_cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}
