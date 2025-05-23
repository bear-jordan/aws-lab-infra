# Networking
resource "aws_vpc" "aws_lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_vpc"
    }
  )
}

## Gateway
resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.aws_lab_vpc.id

  tags = merge(
    var.default_tags,
    {
      Name = "public_gateway"
    }
  )
}

resource "aws_eip" "aws_lab_nat" {
  domain = "vpc"
  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_nat"
    }
  )
}

resource "aws_nat_gateway" "aws_lab_nat_gateway" {
  allocation_id = aws_eip.aws_lab_nat.id
  subnet_id     = aws_subnet.public_subnet_0.id
  depends_on    = [aws_internet_gateway.public_gateway]
  tags = merge(
    var.default_tags,
    {
      Name = "aws_lab_nat_gateway"
    }
  )
}

## Subnets
resource "aws_subnet" "public_subnet_0" {
  vpc_id                  = aws_vpc.aws_lab_vpc.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.default_tags,
    {
      Name = "public_subnet_0"
    }
  )
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.aws_lab_vpc.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.default_tags,
    {
      Name = "public_subnet_1"
    }
  )
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.aws_lab_vpc.id
  cidr_block              = var.public_subnets[2]
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.default_tags,
    {
      Name = "public_subnet_2"
    }
  )
}

resource "aws_subnet" "private_subnet_0" {
  vpc_id            = aws_vpc.aws_lab_vpc.id
  cidr_block        = var.private_subnets[0]
  availability_zone = var.availability_zones[0]
  tags = merge(
    var.default_tags,
    {
      Name = "private_subnet_0"
    }
  )
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.aws_lab_vpc.id
  cidr_block        = var.private_subnets[1]
  availability_zone = var.availability_zones[1]
  tags = merge(
    var.default_tags,
    {
      Name = "private_subnet_1"
    }
  )
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.aws_lab_vpc.id
  cidr_block        = var.private_subnets[2]
  availability_zone = var.availability_zones[2]
  tags = merge(
    var.default_tags,
    {
      Name = "private_subnet_2"
    }
  )
}

## Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.aws_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gateway.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "public_route_table"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.aws_lab_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_lab_nat_gateway.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "private_route_table"
    }
  )
}

resource "aws_route_table_association" "public_route_0" {
  subnet_id      = aws_subnet.public_subnet_0.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_0" {
  subnet_id      = aws_subnet.private_subnet_0.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}
