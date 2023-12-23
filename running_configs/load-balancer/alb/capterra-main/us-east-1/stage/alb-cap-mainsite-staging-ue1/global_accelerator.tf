# resource "aws_globalaccelerator_accelerator" "mainsitealbstagingue1Accelerator" {
#     name                             = "mainsitealbstagingue1Accelerator"
#     ip_address_type                  = "IPV4"
#     enabled                          = true
#     provider                         = aws
# }

# resource "aws_globalaccelerator_listener" "mainsitealbstagingue1AccListener" {
#     provider                         = aws
#     accelerator_arn                  = aws_globalaccelerator_accelerator.mainsitealbstagingue1Accelerator.id
#     client_affinity                  = "NONE"
#     protocol                         = "TCP"
#     port_range {
#       from_port                      = 80
#       to_port                        = 80
#     }
#     port_range {
#       from_port                      = 443
#       to_port                        = 443
#     }
# }

# resource "aws_globalaccelerator_endpoint_group" "mainsitealbstagingue1AccEndpointGrp" {
#     provider                         = aws
#     listener_arn                     = aws_globalaccelerator_listener.mainsitealbstagingue1AccListener.id
#     health_check_interval_seconds    = 30
#     health_check_port                = 80
#     health_check_protocol            = "TCP"
#     traffic_dial_percentage          = 100
#     endpoint_configuration {
#       endpoint_id                    = aws_lb.mainsite-alb-staging-ue1.arn
#       weight                         = 100
#       client_ip_preservation_enabled = true
#     }
# }