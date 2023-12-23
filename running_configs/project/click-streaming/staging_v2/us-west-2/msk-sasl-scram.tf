resource "aws_kms_key" "msk_sasl_scram" {
  description = "Key for kafka in region ${var.region}"
  key_usage   = "ENCRYPT_DECRYPT"
  is_enabled  = true
}

resource "aws_kms_alias" "msk_sasl_scram" {
  name          = "alias/msk/${var.msk_cluster_name}"
  target_key_id = aws_kms_key.msk_sasl_scram.key_id
}

resource "aws_secretsmanager_secret" "msk_sasl_scram" {
  name        = "AmazonMSK_click_streaming_sasl_scram_DR"
  description = "SASL/SCRAM authentication for click-streaming MSK cluster ${var.msk_cluster_name}"
  kms_key_id  = aws_kms_key.msk_sasl_scram.key_id
}

resource "random_password" "msk_sasl_scram_password" {
  length           = 16
  numeric          = true
  upper            = true
  lower            = true
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "aws_secretsmanager_secret_version" "msk_sasl_scram" {
  secret_id     = aws_secretsmanager_secret.msk_sasl_scram.id
  secret_string = <<EOF
   {
    "username": "user",
    "password": "${random_password.msk_sasl_scram_password.result}"
   }
EOF
}

# # Eventually commented
resource "aws_msk_scram_secret_association" "msk_sasl_scram" {
  cluster_arn     = aws_msk_cluster.click_streaming_dr.arn
  secret_arn_list = [aws_secretsmanager_secret.msk_sasl_scram.arn]

  depends_on = [aws_secretsmanager_secret_version.msk_sasl_scram, aws_msk_cluster.click_streaming_dr]
}

resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = aws_secretsmanager_secret.msk_sasl_scram.arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSKafkaResourcePolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "kafka.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.msk_sasl_scram.arn}"
  } ]
}
POLICY
}
