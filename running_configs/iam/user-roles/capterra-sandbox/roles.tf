data "aws_iam_policy_document" "assume_role_admin_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root",
        "arn:aws:iam::176540105868:root",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/assume-${data.aws_iam_account_alias.current.account_alias}-admin"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_read_only_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_developer_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_deployer_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root"]
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
  assume_role_policy  = data.aws_iam_policy_document.assume_role_read_only_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}


resource "aws_iam_role" "developer" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-developer"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_developer_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}


resource "aws_iam_role" "deployer" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-deployer"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_deployer_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}
