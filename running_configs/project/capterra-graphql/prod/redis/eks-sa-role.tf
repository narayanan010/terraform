module "iam_assumable_role_graphql_stage" {
  source = "git@github.com:capterra/terraform.git//modules/eks-sa-pod"

  project_name = var.tag_application
  env          = var.tag_environment
  provider_url = var.eks_oidc
  namespace    = var.namespace
  providers = {
    aws.awscaller_account = aws.awscaller_account
  }
}

data "template_file" "graphql_stage_role_policy_file" {
  template = templatefile("sa-role-policy.json.tpl", { environment = var.environment })
}

resource "aws_iam_policy" "graphql_stage_role_policy" {
  provider    = aws.awscaller_account
  name        = "${var.application}-sa-${var.environment}-access-eks-pod-pol"
  description = "This policy will be applied iam role that will be mapped to service account in EKS ${var.environment} via OIDC for ${var.application} pod in ${var.environment}"
  policy      = data.template_file.graphql_stage_role_policy_file.rendered
}

resource "aws_iam_role_policy_attachment" "graphql_stage_role_policy_attachment" {
  provider = aws.awscaller_account
  depends_on = [
    aws_iam_policy.graphql_stage_role_policy
  ]
  role       = module.iam_assumable_role_graphql_stage.iam_role_name
  policy_arn = aws_iam_policy.graphql_stage_role_policy.arn
}