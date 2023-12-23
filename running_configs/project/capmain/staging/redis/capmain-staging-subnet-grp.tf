# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "tf-subnetgroup-capmain-staging-redis"
resource "aws_elasticache_subnet_group" "tf-subnetgroup-capmain-staging-redis" {
  description = "Subnet group for capmain-staging-redis"
  name        = "tf-subnetgroup-capmain-staging-redis"
  subnet_ids  = ["subnet-017b7c5a2326dd583", "subnet-6414d82c", "subnet-69726f44"]
  tags        = {}
  tags_all    = {}
}
