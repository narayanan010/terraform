data "aws_iam_policy_document" "organizations_workers_permissions" {
  statement {
    sid = "AssumeRole"

    actions = [
      "sts:AssumeRole"
    ]

    resources = var.organizations_role_arn_to_assume_list
  }
}
