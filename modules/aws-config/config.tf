#This section configures AWS recorder and enables it, Creates s3 bucket for config, associates policy to it. Constructs a delivery channel too.
resource "aws_config_configuration_recorder" "accre" {
  count = var.is_config_managed_by_ccoe ? 0 : 1
  role_arn = aws_iam_role.custom-config-rule.arn
  recording_group {
  	all_supported = "true"
  	}
}
resource "aws_config_configuration_recorder_status" "accrs" {
  count = var.is_config_managed_by_ccoe ? 0 : 1
  name       = aws_config_configuration_recorder.accre[0].name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.acdc[0]]
}
resource "aws_config_delivery_channel" "acdc" {
  count = !var.is_config_managed_by_ccoe && !var.is_config_bucket_managed_by_ccoe ? 1 : 0
  name           = "tf-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.as3b[0].bucket
  depends_on     = [aws_config_configuration_recorder.accre[0]]
}
resource "aws_s3_bucket" "as3b" {
  count = var.is_config_bucket_managed_by_ccoe ? 0 : 1

  bucket        = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
}
resource "aws_s3_bucket_policy" "as3bp" {
  count = var.is_config_bucket_managed_by_ccoe ? 0 : 1
  bucket      = aws_s3_bucket.as3b[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSConfigBucketPermissionsCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
        },
        {
            "Sid": "AWSConfigBucketDelivery",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}-${data.aws_caller_identity.current.account_id}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
