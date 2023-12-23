module "eks_onboarding_staging" {
  #source = "git@github.com:capterra/terraform.git//modules/eks-onboarding"
  source = "../../../modules/eks-onboarding"

  region = var.region
  # namespace    = var.namespace
  #namespace    = "team-crf"
  namespace    = "myteam"
  eks_name     = var.eks_name
  eks_iam_role = var.eks_cluster_iam_role_arn
  stage        = var.stage
  vertical     = var.vertical

  iam_deployer_role = var.iam_deployer_role_arn
  eks_deployer_role = var.eks_deployer_role_arn

  bootstrap = var.bootstrap
  tags      = module.tags_resource_module.tags

  namespace_mapping = [
    {
        ecr_repository_tag_team    = "capterra/blog"
        github_repository          = ["capterra/terraform","capterra/graphql","capterra/terraform-poc"]
        # eks_cluster = { 
        #   kms        = "123456"
        #   hostedzone = "DUMMY-ZONE"
        # }
    }
  ]
  #namespace_mapping = var.team_settings
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
