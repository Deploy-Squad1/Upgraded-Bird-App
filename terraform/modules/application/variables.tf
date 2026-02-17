variable "env" {
  description = "The environment all the resources are provisioned in. Included in each resource name tag"
  type        = string
}

variable "project" {
  description = "The project name. Included in resources name tag"
  type        = string
}

variable "ami_id" {
  description = "Amazon Machine Image used by all provided EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that hosts the public and the private subnet"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet. Load balancer is deployed in the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet. The services like application server, database, Consul are deployed in the private subnet"
  type        = string
}

variable "loadbalancer_instance_type" {
  description = "Instance type of the load balancer EC2"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type of the EC2s that host the flask application (deployed as an Auto Scaling group)"
  type        = string
}

variable "asg_desired_capacity" {
  description = "The desired number of EC2 Instances in the Auto Scaling group"
  type        = number
}

variable "asg_min_size" {
  description = "The minimum number of EC2 Instances in the Auto Scaling group"
  type        = number
}

variable "asg_max_size" {
  description = "The maximum number of EC2 Instances in the Auto Scaling group"
  type        = number
}

variable "app_ami_id" {
  description = "AMI of EC2 Instances in the Auto Scaling group"
  type        = string
}

variable "private_instances" {
  description = "Configuration of all the other EC2 instances. Role tag is created for further Ansible configuration"
  type = map(object({
    name          = string
    role          = string
    instance_type = string
  }))

  default = {
    jenkins = {
      name          = "jenkins"
      role          = "jenkins"
      instance_type = "t3.small"
    }
    consul = {
      name          = "consul"
      role          = "consul"
      instance_type = "t3.micro"
    }
    database = {
      name          = "database"
      role          = "database"
      instance_type = "t3.micro"
    }
  }
}
