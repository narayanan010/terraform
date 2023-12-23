data "aws_iam_policy_document" "vendor_portal_api_permissions" {
  statement {
    sid = "AssumeRole"

    actions = [
      "sts:AssumeRole"
    ]

    resources = var.vendor_portal_role_arn_to_assume_list
  }
}
