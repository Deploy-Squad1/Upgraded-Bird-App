resource "aws_security_group" "lb_sg" {
  name = "lb_sg"
  description = "Security group for Load Balancer"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }
  ingress {
    from_port = 8301
    to_port = 8301
    protocol = "tcp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }
  ingress {
    from_port = 8301
    to_port = 8301
    protocol = "udp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }
  ingress {
    from_port = 8600
    to_port = 8600
    protocol = "tcp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }
    ingress {
    from_port = 8600
    to_port = 8600
    protocol = "udp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name = "private_sg"
  description = "Security group for private instances"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 80
    to_port = 8600
    protocol = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }
    ingress {
    from_port = 80
    to_port = 8600
    protocol = "udp"
    security_groups = [aws_security_group.lb_sg.id]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}