
#*************************************************************************************************************************************************************#
#                                                      			       KMS Key     	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_kms_key" "primary_kms_key_aws" {
  provider                 = aws.primary
  count                    = var.primary_kms_arn == "" ? 1 : 0
  description              = "KMS Key for primary DB cluster"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  enable_key_rotation      = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  tags = {
    "region" = data.aws_region.primary_current.name
  }
  policy = <<-EOT

                              {

                                "Version": "2012-10-17",
	                              "Id": "rds-access-primary",
	                              "Statement": [{
	                              	"Sid": "Allow access for the current account that is authorized to use primary DB",
	                              	"Effect": "Allow",
	                              	"Principal": {
	                              		"AWS": "arn:aws:iam::${data.aws_caller_identity.primary_current.account_id}:root"
	                              	},
	                              	"Action": [
	                              		"kms:*"
	                              	],
	                              	"Resource": "*"
	                              }]
                                }
                                EOT
}

resource "aws_kms_key" "secondary_kms_key_aws" {
  provider                 = aws.secondary
  count                    = var.secondary_kms_arn == "" ? 1 : 0
  description              = "KMS Key for secondary DB cluster"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  enable_key_rotation      = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  tags = {
    "region" = data.aws_region.secondary_current.name
  }
  policy = <<-EOT

                              {

                                "Version": "2012-10-17",
	                              "Id": "rds-access-secondary",
	                              "Statement": [{
	                              	"Sid": "Allow access for the current account that is authorized to use secondary DB",
	                              	"Effect": "Allow",
	                              	"Principal": {
	                              		"AWS": "arn:aws:iam::${data.aws_caller_identity.secondary_current.account_id}:root"
	                              	},
	                              	"Action": [
	                              		"kms:*"
	                              	],
	                              	"Resource": "*"
	                              }]
                                }
                                EOT
}