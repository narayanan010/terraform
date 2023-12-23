module "iam_assumable_role_velero_api" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/eks-sa-pod"

  project_name  = "velero"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  inline_policy = data.aws_iam_policy_document.velero_backup_permissions.json
  providers = {
    aws.awscaller_account = aws.main_account
  }
}