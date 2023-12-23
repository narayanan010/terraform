resource "aws_cloudwatch_log_group" "click_streaming_dr" {
  name              = "/aws/msk/${var.msk_cluster_name}"
  retention_in_days = var.msk_cw_logs_retention
}


resource "aws_msk_cluster" "click_streaming_dr" {
  cluster_name           = var.msk_cluster_name
  kafka_version          = var.msk_kafka_version
  number_of_broker_nodes = var.msk_number_of_broker_nodes

  broker_node_group_info {
    instance_type  = var.msk_broker_instance_type
    client_subnets = var.msk_broker_client_subnets
    security_groups = [ # pending to clarify
      aws_security_group.click_streaming_msk_dr.id,
      aws_security_group.click_streaming_msk_dr_ec2.id
    ]
    storage_info {
      ebs_storage_info {
        volume_size = var.msk_broker_ebs_size
        provisioned_throughput {
          enabled = false
        }
      }
    }
  }

  client_authentication {
    sasl {
      iam   = false
      scram = true
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.click_streaming_dr.arn
    revision = aws_msk_configuration.click_streaming_dr.latest_revision
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_sasl_scram.arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
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
        log_group = aws_cloudwatch_log_group.click_streaming_dr.name
      }
      firehose {
        enabled = false
      }
      s3 {
        enabled = false
      }
    }
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

resource "aws_msk_configuration" "click_streaming_dr" {
  kafka_versions = [var.msk_kafka_version]
  name           = var.msk_cluster_name
  description    = "click_streaming_dr from Terraform"

  server_properties = <<PROPERTIES
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=6
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
log.retention.hours=4320
PROPERTIES
}
