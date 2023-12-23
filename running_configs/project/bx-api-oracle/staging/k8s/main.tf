module "iam_assumable_role_bx_api_oracle" {
  source       = "../../../../../modules/eks-sa-pod"
  project_name = "bx-api-oracle"
  env          = var.environment
  provider_url = var.provider_url
  namespace    = var.namespace
  providers = {
    aws.awscaller_account = aws.main_account
  }
}

data "template_file" "role_policy_file" {
  template = file("role-policy.json.tpl")
  vars = {
    environment = var.environment,
    team_tag_0  = var.team_tag[0]
  }
}

resource "aws_iam_policy" "role_policy" {
  provider    = aws.main_account
  name        = "${var.application}-${var.environment}-access-eks-pod-pol"
  description = "This policy will be applied iam role that will be mapped to service account in EKS ${var.environment} via OIDC for ${var.application} pod in ${var.environment}"
  policy      = data.template_file.role_policy_file.rendered
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  provider = aws.main_account
  depends_on = [
    aws_iam_policy.role_policy
  ]
  role       = module.iam_assumable_role_bx_api_oracle.iam_role_name
  policy_arn = aws_iam_policy.role_policy.arn
}