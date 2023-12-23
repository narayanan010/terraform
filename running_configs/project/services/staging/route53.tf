locals {
  domain_name = "capstage.net"
}

data "aws_route53_zone" "capstage" {
  name = local.domain_name
}

locals {
  nginx-stg = [
    {
      hostname    = "nginx-stg-1a",
      public_ip   = "3.214.68.166",
      environment = "staging",
      healthcheck = "616e9f92-c7d2-4666-93f2-6a197b55b64a"
    },
    {
      hostname    = "nginx-stg-1b",
      public_ip   = "52.206.39.209",
      environment = "staging",
      healthcheck = "3a904a54-f6f2-4ae5-b54b-91ad340c04df"
    }
  ]
}

# creating A record for domain: main-services.net
resource "aws_route53_record" "main_service_record" {
  for_each = { for serverlist in local.nginx-stg : serverlist.hostname => serverlist }

  zone_id = data.aws_route53_zone.capstage.zone_id
  name    = "main-${var.application}.${local.domain_name}"
  type    = "A"
  ttl     = 60

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = each.value.hostname
  records        = ["${each.value.public_ip}"]
  health_check_id = each.value.healthcheck
}

# creating A record for domain: cm-services.net
resource "aws_route53_record" "cm_service_record" {
  for_each = { for serverlist in local.nginx-stg : serverlist.hostname => serverlist }

  zone_id = data.aws_route53_zone.capstage.zone_id
  name    = "cm-${var.application}.${local.domain_name}"
  type    = "A"
  ttl     = 60

  weighted_routing_policy {
    weight = 1
  }

  set_identifier = each.value.hostname
  records        = ["${each.value.public_ip}"]
  health_check_id = each.value.healthcheck
}
