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


resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"

  image_id      = "ami-01041c3d1d454088c"

  instance_type = "t3.micro"
  key_name      = "ansible_key"


  vpc_security_group_ids = [aws_security_group.private_sg.id]
  iam_instance_profile {
    name = "ssm-profile"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  vpc_zone_identifier = [aws_subnet.private.id]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Role"
    value               = "app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "App-ASG-Node"
    propagate_at_launch = true
  }
}
