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
    to_port = 8080
    protocol = "tcp"
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