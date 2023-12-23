resource "aws_dlm_lifecycle_policy" "prod-daily-with-no-replication" {
  count              = var.prod_backup_enabled ? 1 : 0
  description        = "Policy to do a DAILY backup of resources in capterra-admin for PROD without REPLICATION"
  execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  state              = "ENABLED"

  tags = {
    Name = "${local.vertical_low}-backup-prod-daily-14-days-no-replication"
  }

  policy_details {
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"
    target_tags = {
      backup-dlm = "prod-no-replication"
    }

    schedule {
      name = "every-24-hours-with-14-days-retention"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["06:00"]
      }
      retain_rule {
        interval      = 14
        interval_unit = "DAYS"
      }
      copy_tags = true
      variable_tags = {
        instance-id = "$(instance-id)"
      }
    }
  }
}

resource "aws_dlm_lifecycle_policy" "prod-weekly-sunday-with-no-replication" {
  count              = var.prod_backup_enabled ? 1 : 0
  description        = "Policy to do a WEEKLY backup of resources in capterra-admin for PROD without REPLICATION"
  execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  state              = "ENABLED"

  tags = {
    Name = "${local.vertical_low}-backup-prod-weekly-sunday-14-weeks-no-replication"
  }

  policy_details {
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"
    target_tags = {
      backup-dlm = "prod-weekly-sunday-no-replication"
    }

    schedule {
      name = "every-week-on-sunday-with-14-weeks-retention"

      create_rule {
        cron_expression = "cron(0 6 ? * SUN *)"
      }
      retain_rule {
        interval      = 14
        interval_unit = "WEEKS"
      }
      copy_tags = true
      variable_tags = {
        instance-id = "$(instance-id)"
      }
    }
  }
}

resource "aws_dlm_lifecycle_policy" "prod-monthly-with-no-replication" {
  count              = var.prod_backup_enabled ? 1 : 0
  description        = "Policy to do a MONTHLY backup of resources in capterra-admin for PROD without REPLICATION"
  execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
  state              = "ENABLED"

  tags = {
    Name = "${local.vertical_low}-backup-prod-monthly-4-copies-no-replication"
  }

  policy_details {
    resource_types = ["INSTANCE"]
    policy_type    = "IMAGE_MANAGEMENT"
    target_tags = {
      backup-dlm = "prod-monthly-no-replication"
    }

    schedule {
      name = "every-month-with-4-months-retention"

      create_rule {
        cron_expression = "cron(0 6 1 * ? *)"
      }
      retain_rule {
        interval      = 4
        interval_unit = "MONTHS"
      }
      copy_tags = true
      variable_tags = {
        instance-id = "$(instance-id)"
      }
    }
  }
}
