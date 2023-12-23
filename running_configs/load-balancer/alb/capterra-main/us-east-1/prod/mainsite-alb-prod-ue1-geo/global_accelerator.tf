resource "aws_globalaccelerator_accelerator" "mainsite-ga-prod-ue1-geo-accelerator" {
    name                             = "mainsite-ga-prod-ue1-geo"
    ip_address_type                  = "IPV4"
    enabled                          = true
    provider                         = aws
}

resource "aws_globalaccelerator_listener" "mainsite-ga-prod-ue1-geo-acc-listener" {
    provider                         = aws
    accelerator_arn                  = aws_globalaccelerator_accelerator.mainsite-ga-prod-ue1-geo-accelerator.id
    client_affinity                  = "NONE"
    protocol                         = "TCP"
    port_range {
      from_port                      = 443
      to_port                        = 443
    }
}

resource "aws_globalaccelerator_endpoint_group" "mainsite-ga-prod-ue1-geo-EndpointGrp" {
    provider                         = aws
    listener_arn                     = aws_globalaccelerator_listener.mainsite-ga-prod-ue1-geo-acc-listener.id
    threshold_count                  = 3
    health_check_path                = "/"
    health_check_interval_seconds    = 30
    health_check_port                = 443
    health_check_protocol            = "HTTPS"
    traffic_dial_percentage          = 100
    endpoint_configuration {
      endpoint_id                    = aws_lb.mainsite-alb-prod-ue1-geo.arn
      weight                         = 128
      client_ip_preservation_enabled = true
    }
}