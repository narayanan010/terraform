resource "aws_vpc_endpoint_service" "atacama-oracle-access_vpce" {
  acceptance_required = true
  network_load_balancer_arns = [aws_lb.atacama-oracle-access.arn]
  provider = aws
}