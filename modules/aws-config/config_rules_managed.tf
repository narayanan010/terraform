resource "aws_config_config_rule" "check_ec2_detailed_monitoring_enabled" {
  name = "check-ec2-detailed-monitoring-enabled"

  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_DETAILED_MONITORING_ENABLED"
  }
}

resource "aws_config_config_rule" "check_required_tags" {
  name = "check-required-tags"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }
  input_parameters = "{\"tag1Key\": \"Name\",\"tag2Key\": \"ENVIRONMENT\",\"tag3Key\": \"app_environment\",\"tag4Key\": \"system_risk_class\",\"tag5Key\": \"business_unit\",\"tag6Key\": \"region\"}"
}
