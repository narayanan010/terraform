resource "aws_kms_key" "msk_sasl_scram" {
  description             = "SASL/SCRAM authentication for Click-streaming MSK Cluster"
  deletion_window_in_days = 10
}


resource "aws_secretsmanager_secret" "msk_sasl_scram" {
  name        = "AmazonMSK_click_streaming_sasl_scram_1"
  description = "SASL/SCRAM authentication for Click-streaming MSK Cluster"
  kms_key_id  = aws_kms_key.msk_sasl_scram.key_id
}


data "aws_ssm_parameter" "msk_sasl_scram" {
  name = "click_streaming_msk_sasl_scram_user"
}


resource "aws_secretsmanager_secret_version" "msk_sasl_scram" {
  secret_id     = aws_secretsmanager_secret.msk_sasl_scram.id
  secret_string = data.aws_ssm_parameter.msk_sasl_scram.value
}

resource "aws_msk_scram_secret_association" "msk_sasl_scram" {
  cluster_arn     = aws_msk_cluster.click_streaming.arn
  secret_arn_list = [aws_secretsmanager_secret.msk_sasl_scram.arn]

  depends_on = [aws_secretsmanager_secret_version.msk_sasl_scram]
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
