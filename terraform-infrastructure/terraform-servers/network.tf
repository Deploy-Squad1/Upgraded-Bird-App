resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags ={ Name = "Birds_VPC" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "Birds_IGW" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Birds_Public_Subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Birds_Public_RT" }
}

resource "aws_route_table_association" "public_rt_assoc" {
   subnet_id      = aws_subnet.public.id
   route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private"{
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = false
  tags = { Name = "Birds_Private_Subnet" }
}

resource "aws_eip" "nat"{
  domain = "vpc"
  tags = { Name = "Birds_NAT_EIP" }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = { Name = "Birds_NAT_GW" }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt"{
  vpc_id = aws_vpc.main.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = { Name = "Birds_Private_RT" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_eip" "lb_eip" {
  instance = aws_instance.lb.id
  tags = { Name = "Birds_LB_EIP" }
}


