module "iam_assumable_role_organizations_api" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "organizations-api"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.organizations_api_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_organizations_consumers" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "organizations-consumers"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.organizations_consumers_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_organizations_workers" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "organizations-workers"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.organizations_workers_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}
