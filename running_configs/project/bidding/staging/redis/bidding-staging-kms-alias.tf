# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "alias/bidding-staging"
resource "aws_kms_alias" "bidding-staging-kms" {
  name          = "alias/bidding-staging"
  name_prefix   = null
  target_key_id = "fb078e93-bf93-4bc4-b7fe-f991f2fe4496"
}
