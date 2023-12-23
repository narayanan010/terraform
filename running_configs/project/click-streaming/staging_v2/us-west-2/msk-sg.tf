resource "aws_security_group" "click_streaming_msk_dr" {
  name        = "click_streaming_msk"
  description = "click-streaming for MSK DR"
  vpc_id      = "vpc-00748ab5d571bcab9"
}

resource "aws_security_group_rule" "click_streaming_internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk_dr.id
}

resource "aws_security_group" "click_streaming_msk_dr_ec2" {
  name        = "click_streaming_msk_ec2"
  description = "Click Streaming MSK (Jenkins, edbas, cd1a)"
  vpc_id      = "vpc-00748ab5d571bcab9"
}

resource "aws_security_group_rule" "click_streaming_msk_ec2_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.click_streaming_msk_dr_ec2.id
}