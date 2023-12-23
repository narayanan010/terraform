resource "aws_cloudwatch_log_group" "declared_data" {
  name              = "/aws/msk/declared-data-staging-ue1"
  retention_in_days = 7
}


resource "aws_msk_cluster" "declared_data" {
  cluster_name           = "capterra-shared-data-msk-staging-ue1"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    ebs_volume_size = 500
    client_subnets  = ["subnet-089258bf9059259d3", "subnet-0272efa24d4855bfb"]
    security_groups = [
      aws_security_group.declared_data_msk.id,
      aws_security_group.declared_data_msk_capterra_ec2.id
    ]
  }

  client_authentication {
    sasl {
      scram = true
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.declared_data.name
      }
      firehose {
        enabled = false
      }
      s3 {
        enabled = false
      }
    }
  }
}


resource "aws_secretsmanager_secret" "declared_data" {
  name       = "AmazonMSK_declared_data_msk_staging"
  kms_key_id = aws_kms_key.declared_data.key_id
}

resource "aws_kms_key" "declared_data" {
  description = "Key for MSK Cluster Scram Secret Association for Declared Data"
}

resource "aws_secretsmanager_secret_version" "declared_data" {
  secret_id     = aws_secretsmanager_secret.declared_data.id
  secret_string = jsonencode({ username = "${var.msk_username}", password = "${var.msk_password}" })
}

resource "aws_secretsmanager_secret_policy" "declared_data" {
  secret_arn = aws_secretsmanager_secret.declared_data.arn
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
    "Resource" : "${aws_secretsmanager_secret.declared_data.arn}"
  } ]
}
POLICY
}

resource "aws_msk_scram_secret_association" "declared_data" {
  cluster_arn     = aws_msk_cluster.declared_data.arn
  secret_arn_list = [aws_secretsmanager_secret.declared_data.arn]

  depends_on = [aws_secretsmanager_secret_version.declared_data]
}