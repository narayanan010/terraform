#########################################################################################
# Terraform Code for running Cloudformation template from scalyr for CW-Logs streaming
# Once lambda is deployed it will stream logs to Scalyr as per subscribe Log-Groups.
# This module will:
  ## Deploy CF-Template will create lambda function to stream CW logs to Scalyr
#########################################################################################


data "aws_caller_identity" "current" {
  provider      = "aws.awscaller_account"
}

provider "aws" {
  alias = "awscaller_account"
  #region = "${var.region_aws}"
}

#provider "aws" {
#  region = "${var.region_aws}"
#}


##This section is for CF-template deployment#################################

resource "aws_cloudformation_stack" "scalyr" {
provider      = "aws.awscaller_account"
  name = "tf-scalyr-cw-stack"

  parameters = {
    AutoSubscribeLogGroups = var.AutoSubscribeLogGroups
    BaseUrl				   = var.BaseUrl
    Debug				   = var.Debug
    LogGroupOptions		   = var.LogGroupOptions
    WriteLogsKey		   = var.WriteLogsKey
    #WriteLogsKeyEncrypted  = var.WriteLogsKeyEncrypted
    WriteLogsKeyEncrypted  = "${aws_kms_ciphertext.akmsct.ciphertext_blob}"
  }

  template_url = var.template_url
  capabilities = ["CAPABILITY_IAM","CAPABILITY_NAMED_IAM","CAPABILITY_AUTO_EXPAND"]

}


##This section is for KMS CMK##################################################
data "template_file" "kms_policy" {
  template = "${file("${path.module}/kms-policy.json.tpl")}"
  vars = {
    account_id  = "${data.aws_caller_identity.current.account_id}"
    #iamusername = "${var.iamusername}"
  }
}

resource "aws_kms_key" "akk" {
provider      = "aws.awscaller_account"
  description             = "This key is used to encrypt scalyr API key"
  deletion_window_in_days = 15
  is_enabled              = "true"
  tags = {
    terraform_managed = "true"
    Application       = "scalyr"
  }
  policy              = data.template_file.kms_policy.rendered
}

resource "aws_kms_alias" "aka" {
provider      = "aws.awscaller_account"
  name_prefix   = "alias/tf-scalyrapikey-encrypt"
  target_key_id = "${aws_kms_key.akk.key_id}"
}

resource "aws_kms_ciphertext" "akmsct" {
provider      = "aws.awscaller_account"
  key_id = aws_kms_key.akk.key_id
  plaintext = var.scalyrplainapikeytoencrypt
}