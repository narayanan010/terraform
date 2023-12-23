resource "datadog_monitor" "msk-offline-replicas" {
  name               = "[Staging-DR] Offline Replicas for ClickStream MSK"
  type               = "metric alert"
  message            = "${var.alerts_to} Replica count offline for click stream, please check replication status."
  escalation_message = "Escalation message ${var.alerts_to}"
  restricted_roles   = [data.datadog_role.dg_admin.id]

  query = "min(last_10m):sum:aws.msk.kafka.server.replica_manager.OfflineReplicaCount{cluster_arn:${aws_msk_cluster.click_streaming_dr.arn}} > 1"

  monitor_thresholds {
    critical = 1
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))

  depends_on = [aws_msk_cluster.click_streaming_dr]
}


resource "datadog_monitor" "msk-consumer-lag" {
  name = "[Staging-DR] ClickStream consumer lag is high"
  type = "metric alert"
  # @slack-alert_click_streaming_stg
  message            = "${var.alerts_to} Consumer group for Staging-DR click stream is lagging, please check the stream readers."
  escalation_message = "Consumer group lag is still high - failure to correct this could lead to exhausted storage capacity and lost clickstream data."
  restricted_roles   = [data.datadog_role.dg_admin.id]
  new_group_delay    = 60

  query = "avg(last_5m):sum:aws.msk.kafka.consumer.group.ConsumerLagMetrics.Value{cluster_arn:${aws_msk_cluster.click_streaming_dr.arn}} by {cluster_arn, topic,groupid} > 1800"

  monitor_thresholds {
    ok       = 600
    warning  = 900
    critical = 1800
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))

  depends_on = [aws_msk_cluster.click_streaming_dr]
}

resource "datadog_monitor" "msk-low-data" {
  name               = "[Staging-DR] Unexpectedly low clickstream volume"
  type               = "metric alert"
  message            = "${var.alerts_to} Click volue in Staging-DR click stream is low, please check the stream readers."
  escalation_message = "Click volume still low, are we losing clicks?"
  restricted_roles   = [data.datadog_role.dg_admin.id]

  query = "max(last_1h):per_minute(sum:aws.msk.kafka.server.broker_topics.MessagesInPerSec{topic:click_stream,cluster_arn:${aws_msk_cluster.click_streaming_dr.arn}}) < 1"

  monitor_thresholds {
    warning  = 2
    critical = 1
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))

  depends_on = [aws_msk_cluster.click_streaming_dr]
}


resource "datadog_monitor" "msk-under-replicated-partitions" {
  name               = "[Staging-DR] Partitions are under-replicated in ClickStream MSK"
  type               = "metric alert"
  message            = "${var.alerts_to} partitions are not fully replicated, data consistency is at risk."
  escalation_message = "Partitions have still not fully replicated, failure to correct this could lead to lost clickstream data."
  restricted_roles   = [data.datadog_role.dg_admin.id]

  query = "max(last_10m):sum:aws.msk.kafka.server.replica_manager.UnderMinIsrPartitionCount{cluster_arn IN (${aws_msk_cluster.click_streaming_dr.arn})} > 0"


  monitor_thresholds {
    critical = 0
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))

  depends_on = [aws_msk_cluster.click_streaming_dr]
}


resource "datadog_monitor" "msk-storage-space" {
  name    = "[Staging-DR] Storage space is unexpectedly low in MSK"
  type    = "metric alert"
  message = "${var.alerts_to} Storage is getting low in MSK on at least one broker - If storage becomes exhausted, writes will fail and data will be lost.\n\n If we've grown and this is expected, please expand the clusters storage space, otherwise, most likely there is a consumer fault that needs to be investigated."

  query            = "avg(last_15m):min:aws.msk.node.filesystem.free.bytes{cluster_arn:${aws_msk_cluster.click_streaming_dr.arn}} by {broker_id} < 20000000000"
  restricted_roles = [data.datadog_role.dg_admin.id]


  monitor_thresholds {
    critical = 20000000000
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))

  depends_on = [aws_msk_cluster.click_streaming_dr]
}