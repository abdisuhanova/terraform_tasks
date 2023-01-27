locals {
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  internet = "0.0.0.0/0"
  name        = "a"
  vpc = aws_vpc.main.id
  subnets = aws_subnet.main.*.id
  security_group = aws_security_group.sg.id
  road = aws_route_table.routes.id

  ingress_rules = [
    {port = 80},
    {port = 22}
  ]
  names = ["subnet1","subnet2","subnet3"]
}