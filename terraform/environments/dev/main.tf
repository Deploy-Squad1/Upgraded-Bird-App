provider "aws" {
  region = "eu-central-1"
}

module "network" {
  source = "../../modules/network"

  env               = var.env
  project           = var.project
  availability_zone = var.availability_zone
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

module "instances" {
  source = "../../modules/application"

  env                        = var.env
  project                    = var.project
  ami_id                     = data.aws_ami.ubuntu.id
  vpc_id                     = module.network.vpc_id
  private_subnet_id          = module.network.private_subnet_id
  public_subnet_id           = module.network.public_subnet_id
  loadbalancer_instance_type = var.loadbalancer_instance_type
  private_instances          = var.private_instances
}


