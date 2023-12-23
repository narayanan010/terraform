data "aws_iam_policy_document" "assume_role_admin_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::237884149494:root"]
    }
  }
}


resource "aws_iam_role" "admin" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-admin"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}


resource "aws_iam_role" "readonly" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-readonly"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}


resource "aws_iam_role" "developer" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-developer"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}


resource "aws_iam_role" "deployer" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-deployer"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess", aws_iam_policy.deployer.arn]
}
