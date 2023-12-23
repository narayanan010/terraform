module "iam_assumable_role_vendor_portal_api" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "vendor-portal-api"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.vendor_portal_api_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_vendor_portal_consumers" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "vendor-portal-consumers"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.vendor_portal_consumers_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_vendor_portal_workers" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "vendor-portal-workers"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.vendor_portal_workers_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}
