variable "env" {
  description = "The environment all the resources are provisioned in. Included in each resource name tag"
  type        = string
}

variable "project" {
  description = "The project name. Included in each resource name tag"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone where subnets are created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "IPv4 address range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "IPv4 address range for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "IPv4 address range for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}
