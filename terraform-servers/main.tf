data "aws_ami" "ubuntu"{
  most_recent = true
  owners = ["099720109477"]
  filter{
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "lb" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.lb_sg.id]
  iam_instance_profile = "ssm-profile"
  key_name = "ansible_key"
  tags = {
    Name= "LoadBalancer"
    Role= "loadbalancer"
  }
}

locals{
   private_instances = {
    Jenkins = "jenkins"
    App1 = "app"
    App2 = "app"
    Database = "database"
    Consul = "consul"
  }
}

resource "aws_instance" "instances" {
  for_each             = local.private_instances
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.private.id
  iam_instance_profile = "ssm-profile"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name = "ansible_key"
  tags = {
    Name = each.key
    Role = each.value
  }
}
