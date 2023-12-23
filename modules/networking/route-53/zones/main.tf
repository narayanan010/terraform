resource "aws_route53_zone" "this" {
  for_each = { for k, v in var.zones : k => v }

  name          = lookup(each.value, "domain_name", each.key)
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  delegation_set_id = lookup(each.value, "delegation_set_id", null)

  dynamic "vpc" {
    for_each = { for k, v in lookup(each.value, "vpc", null) : k => v }

    content {
      vpc_id     = lookup(vpc.value, "id", null)
      vpc_region = lookup(vpc.value, "region", null)
    }
  }

}
