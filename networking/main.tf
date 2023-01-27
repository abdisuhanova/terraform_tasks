//VPC CREATION
resource "aws_vpc" "main" {
  cidr_block       = local.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

//INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = local.vpc

  tags = {
    Name = "main"
  }
  depends_on = [
    aws_vpc.main,
  ]
}

//ROUTE TABLES
resource "aws_route_table" "routes" {
  vpc_id = local.vpc

  route {
    cidr_block = local.internet
    gateway_id = aws_internet_gateway.gw.id
  }
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.gw
  ]
}

 //CREATING SUBNETS
data "aws_availability_zones" "available" {}

resource "aws_subnet" "main" {
  count = "${length(local.names)}"
  vpc_id     = local.vpc
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
      Name = "sub${count.index}"
  }
  depends_on = [
    aws_vpc.main
  ]
}

//ROUTE TABLE CONNECTING
resource "aws_route_table_association" "as" {
  for_each = toset(local.subnets)
  subnet_id      = each.key
  route_table_id = local.road
  depends_on = [
    aws_route_table.routes,
    aws_subnet.main
  ]
}

//SECURITY GROUP
resource "aws_security_group" "sg" {
  name        = "security"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port = ingress.value["port"]
      to_port = ingress.value["port"]
      protocol = "tcp"
      cidr_blocks = [local.internet]
    }
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [local.internet]
}
depends_on = [
  aws_vpc.main
]
}