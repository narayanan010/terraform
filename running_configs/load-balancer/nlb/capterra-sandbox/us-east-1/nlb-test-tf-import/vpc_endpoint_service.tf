resource "aws_vpc_endpoint_service" "nlb_sandbox_pvt_link" {
  acceptance_required = true
  network_load_balancer_arns = [aws_lb.nlb-test-tf-import.arn]
  provider = aws
}