resource "datadog_monitor" "rule_anomalies" {
  count              = var.waf_dd_alerts_to == "" ? 0 : 1
  name               = "[${var.stage}] WAF rule anomaly elevated for ${aws_wafv2_web_acl.waf-acl.name}"
  type               = "metric alert"
  message            = "${var.waf_dd_alerts_to}: Block-rate for rule {labelname} is abnormal"
  escalation_message = "${var.waf_dd_alerts_to}: Block-rate for rule {labelname} remains abnormal"

  query = "avg(last_30m):anomalies(avg:aws.wafv2.blocked_requests{webacl:${aws_wafv2_web_acl.waf-acl.name}} by {labelname}, 'agile', 2, direction='above', interval=60, alert_window='last_30m', seasonality='hourly', timezone='utc', count_default_zero='true') >= 1"

  monitor_threshold_windows {
    recovery_window = "last_15m"
    trigger_window  = "last_30m"
  }

  include_tags = true

  renotify_interval = 120
  renotify_statuses = ["alert", "warn", "no data"]
  tags              = [var.stage, var.vertical]
}
