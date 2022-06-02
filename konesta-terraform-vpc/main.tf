provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

#public subnet 1
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_a
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-subnet-a"
  }
}

#private subnet 
resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_b
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.ENVIRONMENT}-subnet-b"
  }
}

#public subnet
resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_b
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-subnet-c"
  }
}

# Creating Private Subnet for database
resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_b
  map_public_ip_on_launch = "false"
  
  tags = {
    Name = "db_subnet"
  }
}

# Creating Database Subnet group under our VPC
resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds_db"
  subnet_ids = [aws_subnet.db_subnet.id ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_route_table" "subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# ELastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.igw]
}

# NAT gateway for private ip address
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_a.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.ENVIRONMENT}-vpc-NAT-gateway"
  }
}


resource "aws_route" "subnet_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.subnet_route_table.id
}

# Route table for Private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-private-route-table"
  }
}

resource "aws_route_table_association" "subnet_a_route_table_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.subnet_route_table.id
}

resource "aws_route_table_association" "subnet_b_route_table_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.subnet_route_table.id
}

resource "aws_route_table_association" "subnet_c_route_table_association" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.subnet_route_table.id
}