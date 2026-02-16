variable "env" {
  description = "The environment all the resources are provisioned in. Included in each resource name tag"
  type        = string
}

variable "project" {
  description = "The project name. Included in resources name tag"
  type        = string
}

variable "vpc_cidr_block" {
  description = "IPv4 address range for the VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "IPv4 address range for the public subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "IPv4 address range for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone where subnets are created"
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

variable "private_instances" {
  description = "Configuration of all the other EC2 instances. Role tag is created for further Ansible configuration"
  type = map(object({
    name          = string
    role          = string
    instance_type = string
  }))
}
