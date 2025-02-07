provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-east-1"
}
variable "az1" {
  default = "us-east-1a"
}
variable "az2" {
  default = "us-east-1b"
}
variable "myName" {
  type = string
  default = "meitar"
}

resource "aws_vpc" "vpc_meitar" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.myName}-vpc"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_meitar.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.az1

  tags = {
    Name = "${var.myName}-publicSubnet"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_meitar.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = var.az2

  tags = {
    Name = "${var.myName}-privateSubnet"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_meitar.id

  tags = {
    Name = "${var.myName}-internetGateway"
  }
}
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.myName}-routeTable-public"
  }
}
resource "aws_route_table_association" "rtAssociation_publicSN" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_meitar.id

  tags = {
   Name = "${var.myName}-routeTable-private"
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt_private.id
}