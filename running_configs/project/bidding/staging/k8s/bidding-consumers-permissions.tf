data "aws_iam_policy_document" "bidding_consumers_permissions" {
  statement {
    sid = "AssumeRole"

    actions = [
      "sts:AssumeRole"
    ]

    resources = var.bidding_role_arn_to_assume_list
  }
}
