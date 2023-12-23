module "iam_assumable_role_bidding_api" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "bidding-api"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.bidding_api_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_bidding_consumers" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "bidding-consumers"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.bidding_consumers_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_bidding_workers" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "bidding-workers"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.bidding_workers_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

module "iam_assumable_role_bidding_cronjobs" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "bidding-cronjobs"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.bidding_cronjobs_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}
