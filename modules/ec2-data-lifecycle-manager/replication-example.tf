#### CROSS REGION REPLICATION NOT SUPPORTED AT THE MOMENT - KEEP FOR THE FUTURE ####
#### BUG LINK: https://github.com/hashicorp/terraform-provider-aws/issues/24226 ####
# resource "aws_dlm_lifecycle_policy" "prod-daily-with-replication" {
#   count              = var.prod_backup_enabled ? 1 : 0
#   description        = "Policy to do a backup of resources in capterra-admin for PROD with REPLICATION"
#   execution_role_arn = var.dlm_lifecycle_role_arn != "" ? var.dlm_lifecycle_role_arn : "arn:aws:iam::${local.account_id}:role/service-role/AWSDataLifecycleManagerDefaultRoleForAMIManagement"
#   state              = "ENABLED"

#   tags = {
#     Name = "${local.vertical_low}-backup-prod-daily-7-days"
#   }

#   policy_details {
#     resource_types = ["INSTANCE"]
#     policy_type = "IMAGE_MANAGEMENT"
#     target_tags = {
#       backup-dlm = "prod"
#     }

#     schedule {
#       name = "every-24-hours-with-14-days-retention"

#       create_rule {
#         interval      = 24
#         interval_unit = "HOURS"
#         times         = ["06:00"]
#       }
#       retain_rule {
#         interval      = 14
#         interval_unit = "DAYS"
#       }
#       tags_to_add = {
#         SnapshotCreator = "DLM"
#       }
#       copy_tags = true
#       variable_tags = {
#         instance-id = "$(instance-id)"
#       }

#       cross_region_copy_rule {
#         target    = var.modulecaller_source_region == "us-east-1" ? "us-west-2" : "us-east-1"
#         encrypted = true
#         cmk_arn   = var.cross_region_key_arn != "" ? var.cross_region_key_arn : null
#         copy_tags = true
#         retain_rule {
#           interval      = 14
#           interval_unit = "DAYS"
#         }
#       }
#     }

#   }
# }
