# Network Module
# main.tf


# Virtual Private Network
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.vpc_dns_support   # true
  enable_dns_hostnames = var.vpc_dns_hostnames # true

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.igw_name
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_az
  map_public_ip_on_launch = var.map_public_ip # true

  tags = {
    Name = var.public_subnet_name
  }
}

# Private Subnet_1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_block_1
  availability_zone = var.private_subnet_az_1

  tags = {
    Name = "${var.private_subnet_name}-1"
  }
}

# Private Subnet_2
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_block_2
  availability_zone = var.private_subnet_az_2

  tags = {
    Name = "${var.private_subnet_name}-2"
  }
}

# Private Subnet Group
resource "aws_db_subnet_group" "this" {
  name = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]

  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}

# Public Subnet Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.public_route_table_cidr # "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# Private Subnets Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.private_route_table_name
  }
}

# Public Subnet and Route Table Association
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Subnet_1 and Route Table Association
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

# Private Subnet_2 and Route Table Association
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# VPC Endpoint
resource "aws_vpc_endpoint" "this" {
  vpc_id            = aws_vpc.this.id
  service_name      = var.vpc_endpoint_service_name
  vpc_endpoint_type = var.vpc_endpoint_type # "Gateway"
}

# VPC Endpoint and Route Table Association
resource "aws_vpc_endpoint_route_table_association" "this" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.this.id
}
