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
