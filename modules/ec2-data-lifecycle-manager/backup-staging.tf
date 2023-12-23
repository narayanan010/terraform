resource "aws_dlm_lifecycle_policy" "staging-daily-with-no-replication" {
  count              = var.staging_backup_enabled ? 1 : 0
  description        = "Policy to do a DAILY backup of resources in capterra-admin for STAGING without REPLICATION"
  execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  state              = "ENABLED"

  tags = {
    Name = "${local.vertical_low}-backup-staging-daily-7-days-no-replication"
  }

  policy_details {
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"
    target_tags = {
      backup-dlm = "staging-no-replication"
    }

    schedule {
      name = "every-24-hours-with-7-days-retention"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["06:00"]
      }
      retain_rule {
        interval      = 7
        interval_unit = "DAYS"
      }
      copy_tags = true
      variable_tags = {
        instance-id = "$(instance-id)"
      }
    }
  }
}

resource "aws_dlm_lifecycle_policy" "staging-weekly-sunday-with-no-replication" {
  count              = var.staging_backup_enabled ? 1 : 0
  description        = "Policy to do a WEEKLY backup of resources in capterra-admin for STAGING without REPLICATION"
  execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  state              = "ENABLED"

  tags = {
    Name = "${local.vertical_low}-backup-staging-weekly-sunday-7-weeks-no-replication"
  }

  policy_details {
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"
    target_tags = {
      backup-dlm = "staging-weekly-sunday-no-replication"
    }

    schedule {
      name = "every-week-on-sunday-with-7-weeks-retention"

      create_rule {
        cron_expression = "cron(0 6 ? * SUN *)"
      }
      retain_rule {
        interval      = 7
        interval_unit = "WEEKS"
      }
      copy_tags = true
      variable_tags = {
        instance-id = "$(instance-id)"
      }
    }
  }
}

resource "aws_dlm_lifecycle_policy" "staging-monthly-with-no-replication" {
  count              = var.staging_backup_enabled ? 1 : 0
  description        = "Policy to do a MONTHLY backup of resources in capterra-admin for STAGING without REPLICATION"
  execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  state              = "ENABLED"

  tags = {
    Name = "${local.vertical_low}-backup-staging-monthly-2-copies-no-replication"
  }

  policy_details {
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"
    target_tags = {
      backup-dlm = "staging-monthly-no-replication"
    }

    schedule {
      name = "every-month-with-2-months-retention"

      create_rule {
        cron_expression = "cron(0 6 1 * ? *)"
      }
      retain_rule {
        interval      = 2
        interval_unit = "MONTHS"
      }
      copy_tags = true
      variable_tags = {
        instance-id = "$(instance-id)"
      }
    }
  }
}
