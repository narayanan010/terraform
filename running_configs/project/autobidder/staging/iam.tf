module "iam_assumable_role_autobidder" {
  source        = "git@github.com:capterra/terraform.git//modules/eks-sa-pod"
  project_name  = "${var.application}"
  env           = var.environment
  provider_url  = "oidc.eks.us-east-1.amazonaws.com/id/25A06630668756A639F64BB6A74AA760"
  namespace     = var.namespace
  providers     = {
    aws.awscaller_account               = aws.awscaller_account
  }
}

data "template_file" "sa_role_policy_file" {
  template      = "${file("sa-role-policy.json.tpl")}"
}

resource "aws_iam_policy" "autobidder_stage_role_policy" {
  provider      = aws.awscaller_account
  name          = "${var.application}-sa-${var.environment}-access-eks-pod-pol"
  description   = "This policy will be applied iam role that will be mapped to service account in EKS ${var.environment} via OIDC for ${var.application} pod in ${var.environment}"
  policy        = data.template_file.sa_role_policy_file.rendered
}

resource "aws_iam_role_policy_attachment" "autobidder_stage_role_policy_attachment" {
  provider      = aws.awscaller_account
  depends_on    = [
    aws_iam_policy.autobidder_stage_role_policy
  ]
  role          = module.iam_assumable_role_autobidder.iam_role_name
  policy_arn    = aws_iam_policy.autobidder_stage_role_policy.arn
}