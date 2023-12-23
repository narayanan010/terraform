# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "alias/capmain-staging-redis"
resource "aws_kms_alias" "capmain-staging-redis-kms-alias" {
  name          = "alias/capmain-staging-redis"
  name_prefix   = null
  target_key_id = "a4b8d5bd-e03d-484c-900e-d93c63374ab4"
}
