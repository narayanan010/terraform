resource "datadog_monitor" "msk-offline-replicas" {
  name               = "[Production] Offline Replicas for ClickStream MSK"
  type               = "metric alert"
  message            = "Monitor triggered. Notify: @james.nurmi@toptal.com"
  escalation_message = "Escalation message ${var.alerts_to}"
  restricted_roles   = [data.datadog_role.dg_admin.id]

  query = "min(last_10m):sum:aws.msk.kafka.server.replica_manager.OfflineReplicaCount{cluster_arn:${aws_msk_cluster.click_streaming.arn}} > 1"

  monitor_thresholds {
    critical = 1
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))
}


resource "datadog_monitor" "msk-consumer-lag" {
  name               = "[Production] ClickStream consumer lag is high"
  type               = "metric alert"
  message            = "${var.alerts_to} Consumer group for production click stream is lagging, please check the stream readers."
  escalation_message = "Consumer group lag is still high - failure to correct this could lead to exhausted storage capacity and lost clickstream data."
  restricted_roles   = [data.datadog_role.dg_admin.id]
  new_group_delay    = 60

  query = "avg(last_5m):sum:aws.msk.kafka.consumer.group.ConsumerLagMetrics.Value{cluster_arn IN (${aws_msk_cluster.click_streaming.arn}) AND groupid IN (clks-oracle-consumer-1,clks-dynamodb-consumer-1)} by {cluster_arn,topic,groupid} > 1800"

  monitor_thresholds {
    ok       = 600
    warning  = 900
    critical = 1800
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))
}

resource "datadog_monitor" "msk-low-data" {
  name               = "[Production] Unexpectedly low clickstream volume"
  type               = "metric alert"
  message            = "${var.alerts_to} Consumer group for production click stream is lagging, please check the stream readers."
  escalation_message = "Consumer group lag is still high - failure to correct this could lead to exhausted storage capacity and lost clickstream data."
  restricted_roles   = [data.datadog_role.dg_admin.id]

  query = "max(last_1h):per_minute(sum:aws.msk.kafka.server.broker_topics.MessagesInPerSec{topic:click_stream,cluster_arn:${aws_msk_cluster.click_streaming.arn}}) < 1"

  monitor_thresholds {
    warning  = 2
    critical = 1
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))
}


resource "datadog_monitor" "msk-under-replicated-partitions" {
  name               = "[Production] Partitions are under-replicated in ClickStream MSK"
  type               = "metric alert"
  message            = "${var.alerts_to} partitions are not fully replicated, data consistency is at risk."
  escalation_message = "Partitions have still not fully replicated, failure to correct this could lead to lost clickstream data."
  restricted_roles   = [data.datadog_role.dg_admin.id]

  query = "max(last_10m):sum:aws.msk.kafka.server.replica_manager.UnderMinIsrPartitionCount{cluster_arn:${aws_msk_cluster.click_streaming.arn}} > 0"

  monitor_thresholds {
    critical = 0
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))
}


resource "datadog_monitor" "msk-storage-space" {
  name    = "[Production] Storage space is unexpectedly low in MSK"
  type    = "metric alert"
  message = "${var.alerts_to} Storage is getting low in MSK on at least one broker - If storage becomes exhausted, writes will fail and data will be lost.\n\n If we've grown and this is expected, please expand the clusters storage space, otherwise, most likely there is a consumer fault that needs to be investigated."

  query            = "avg(last_15m):min:aws.msk.node.filesystem.free.bytes{cluster_arn:${aws_msk_cluster.click_streaming.arn}} by {broker_id} < 20000000000"
  restricted_roles = [data.datadog_role.dg_admin.id]


  monitor_thresholds {
    critical = 20000000000
  }

  include_tags = true

  renotify_interval = 30
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = concat(["msk"], values(module.tags_resource_module.tags))
}
