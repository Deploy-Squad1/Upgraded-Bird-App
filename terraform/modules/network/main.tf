resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-${var.project}-internet-gateway"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.project}-public-subnet"
  }
}

resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-${var.project}-public-subnet-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_subnet.id
}


resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.project}-private-subnet"
  }
}

resource "aws_eip" "nat_address" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-${var.project}-nat-address"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_address.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "${var.env}-${var.project}-nat-gateway"
  }
}

resource "aws_route_table" "private_subnet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.env}-${var.project}-private-subnet-route-table"
  }
}

resource "aws_route_table_association" "private_route_table_assosiation" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_subnet.id
}
