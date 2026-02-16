resource "aws_eip" "loadbalancer" {
  instance = aws_instance.loadbalancer.id
  tags = {
    Name = "${var.env}-${var.project}-loadbalancer-address"
  }
}

resource "aws_instance" "loadbalancer" {
  ami                    = var.ami_id
  instance_type          = var.loadbalancer_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.loadbalancer.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  key_name               = aws_key_pair.ansible_key.key_name
  tags = {
    Name        = "${var.env}-${var.project}-loadbalancer"
    Role        = "loadbalancer"
    Environment = var.env
  }
}

resource "aws_instance" "private_instances" {
  for_each               = var.private_instances
  ami                    = var.ami_id
  instance_type          = each.value["instance_type"]
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.internal_services.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  key_name               = aws_key_pair.ansible_key.key_name
  tags = {
    Name        = "${var.env}-${var.project}-${each.value["name"]}"
    Role        = each.value["role"]
    Environment = var.env
  }
}

resource "aws_launch_template" "app" {
  name                   = "${var.env}-${var.project}-app-lt"
  image_id               = var.ami_id
  instance_type          = var.app_instance_type
  key_name               = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids = [aws_security_group.internal_services.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name             = "${var.env}-${var.project}-app-asg"
  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size


  vpc_zone_identifier = [var.private_subnet_id]

  launch_template {
    id      = aws_launch_template.app.id
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
    value               = "${var.env}-${var.project}-App-ASG-Node"
    propagate_at_launch = true
  }
}
