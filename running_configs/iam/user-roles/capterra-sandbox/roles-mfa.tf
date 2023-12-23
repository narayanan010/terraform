data "aws_iam_policy_document" "assume_role_admin_account_mfa" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/assume-${data.aws_iam_account_alias.current.account_alias}-admin-mfa"]
    }

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

data "aws_iam_policy_document" "assume_role_read_only_account_mfa" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root"]
    }

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

data "aws_iam_policy_document" "assume_role_developer_account_mfa" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root"]
    }

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

data "aws_iam_policy_document" "assume_role_deployer_account_mfa" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::237884149494:root"]
    }

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

resource "aws_iam_role" "admin_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-admin-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account_mfa.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}


resource "aws_iam_role" "readonly_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-readonly-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_read_only_account_mfa.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonMemoryDBReadOnlyAccess"]
}


resource "aws_iam_role" "developer_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-developer-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_developer_account_mfa.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}


resource "aws_iam_role" "deployer_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-deployer-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_deployer_account_mfa.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}
