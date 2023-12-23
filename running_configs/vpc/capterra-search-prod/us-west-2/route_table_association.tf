resource "aws_route_table_association" "subnet-06b11e1f55980a35c" {
  route_table_id = aws_route_table.rtb-06a7fd6c63baa7f20.id
  subnet_id      = "subnet-06b11e1f55980a35c"
}

resource "aws_route_table_association" "subnet-08b05163ffb5a2c31" {
  route_table_id = aws_route_table.rtb-0a3a44adfcd1c3cd4.id
  subnet_id      = "subnet-08b05163ffb5a2c31"
}

resource "aws_route_table_association" "subnet-08eb96f92f58c5aa5" {
  route_table_id = aws_route_table.rtb-06a7fd6c63baa7f20.id
  subnet_id      = "subnet-08eb96f92f58c5aa5"
}

resource "aws_route_table_association" "subnet-095309c0629cd20bf" {
  route_table_id = aws_route_table.rtb-06a7fd6c63baa7f20.id
  subnet_id      = "subnet-095309c0629cd20bf"
}

resource "aws_route_table_association" "subnet-0b575f7aa82e4d0f2" {
  route_table_id = aws_route_table.rtb-06a7fd6c63baa7f20.id
  subnet_id      = "subnet-0b575f7aa82e4d0f2"
}
