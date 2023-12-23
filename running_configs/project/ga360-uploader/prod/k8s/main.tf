module "iam_assumable_role_cronjob" {
  source        = "../../../../../modules/eks-sa-pod"
  project_name  = "${var.application}-cronjob"
  env           = var.environment
  provider_url  = var.provider_url
  namespace     = var.namespace
  providers     = {
    aws.awscaller_account               = aws.awscaller_account
  }
}

data "template_file" "cronjob_role_policy_file" {
  template      = "${file("cronjob-role-policy.json.tpl")}"
  # vars = {
  #   cronjob_role_arn_for_cognito = var.cronjob_role_arn_for_cognito
  # }
}

resource "aws_iam_policy" "cronjob_role_policy" {
  provider      = aws.awscaller_account
  name          = "${var.application}-cronjob-${var.environment}-access-eks-pod-pol"
  description   = "This policy will be applied iam role that will be mapped to service account in EKS ${var.environment} via OIDC for ${var.application} pod in ${var.environment}"
  policy        = data.template_file.cronjob_role_policy_file.rendered
}

resource "aws_iam_role_policy_attachment" "cronjob_role_policy_attachment" {
  provider      = aws.awscaller_account
  depends_on    = [
    aws_iam_policy.cronjob_role_policy
  ]
  role          = module.iam_assumable_role_cronjob.iam_role_name
  policy_arn    = aws_iam_policy.cronjob_role_policy.arn
}