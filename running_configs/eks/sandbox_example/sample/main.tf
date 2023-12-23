

module "eks_onboarding_sandbox" {
  source = "git@github.com:capterra/terraform.git//modules/eks-onboarding"

  region       = var.region
  namespace    = var.namespace
  eks_name     = var.eks_name
  eks_iam_role = data.terraform_remote_state.eks_cluster_sandbox.outputs.eks_cluster_iam_role_arn
  stage        = var.stage
  vertical     = var.vertical

  iam_deployer_role = var.iam_deployer_role_arn
  eks_deployer_role = var.eks_deployer_role_arn

  tags = module.tags_resource_module.tags
}

module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = var.application
  app_component       = var.app_component
  function            = var.function
  business_unit       = var.business_unit
  app_environment     = var.environment
  app_contacts        = var.app_contacts
  created_by          = var.created_by
  system_risk_class   = var.system_risk_class
  region              = var.region
  network_environment = var.environment
  monitoring          = var.monitoring
  terraform_managed   = var.terraform_managed
  vertical            = var.vertical
  product             = var.product
  environment         = var.environment
}
