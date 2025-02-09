resource "aws_vpc" "vpc_meitar" {
  cidr_block = "10.0.0.0/${var.cidrBlockRange}"//var.cidrBlock
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.myName}-vpc"
  }
}
# Shuffle the availability zones
resource "random_shuffle" "az_shuffle" {
  input        = var.availability_zones
  result_count = var.countPublicSubnets + var.countPrivateSubnets // Total amount of subnets to assign the azs to
}
resource "aws_subnet" "public_subnet" {
  count=var.countPublicSubnets
  vpc_id     = aws_vpc.vpc_meitar.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
 //availability_zone = var.az1
  availability_zone = random_shuffle.az_shuffle.result[count.index]  


  tags = {
    Name = "${var.myName}-publicSubnet${count.index}"
  }
}
resource "aws_subnet" "private_subnet" {
  count=var.countPrivateSubnets
  vpc_id     = aws_vpc.vpc_meitar.id
  cidr_block = "10.0.${count.index + var.countPublicSubnets+1}.0/24"
  map_public_ip_on_launch = false
  //availability_zone = var.az2
  availability_zone = random_shuffle.az_shuffle.result[count.index + var.countPublicSubnets]  

  tags = {
    Name = "${var.myName}-privateSubnet${count.index}"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_meitar.id

  tags = {
    Name = "${var.myName}-internetGateway"
  }
}
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_meitar.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.myName}-routeTable-public"
  }
}
resource "aws_route_table_association" "rtAssociation_publicSN" {
  count          = var.countPublicSubnets
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_meitar.id

  tags = {
   Name = "${var.myName}-routeTable-private"
  }
}
resource "aws_route_table_association" "private" {
  count          = var.countPrivateSubnets
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.rt_private.id
}
