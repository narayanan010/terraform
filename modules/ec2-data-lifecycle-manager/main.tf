data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  vertical     = var.vertical
  vertical_low = lower(var.vertical)
}
