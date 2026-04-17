# Search for the Jenkins VPC
data "aws_vpc" "jenkins_vpc" {
  filter {
    name   = "tag:Name"
    values = ["secret-society-stage-vpc"] 
  }
}

data "aws_route_table" "jenkins_public_rt" {
  vpc_id = data.aws_vpc.jenkins_vpc.id
  filter {
    name   = "tag:Name"
    values = ["secret-society-stage-public-rt"] 
  }
}

# Create VPC peering connection between Bird and Jenkins VPCs
resource "aws_vpc_peering_connection" "bird_to_jenkins" {
  vpc_id      = module.network.vpc_id
  peer_vpc_id = data.aws_vpc.jenkins_vpc.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "${var.env}-${var.project}-to-jenkins-peering"
  }
}

# Jenkins to Birdwatching
resource "aws_route" "from_jenkins_to_bird" {
  route_table_id            = data.aws_route_table.jenkins_public_rt.id
  destination_cidr_block    = module.network.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bird_to_jenkins.id
}

# Birdwatching to Jenkins
resource "aws_route" "from_bird_private_to_jenkins" {
  route_table_id            = module.network.private_subnet_route_table_id
  destination_cidr_block    = data.aws_vpc.jenkins_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bird_to_jenkins.id

  depends_on = [aws_vpc_peering_connection.bird_to_jenkins]
}

resource "aws_route" "from_bird_public_to_jenkins" {
  route_table_id            = module.network.public_subnet_route_table_id
  destination_cidr_block    = data.aws_vpc.jenkins_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.bird_to_jenkins.id

  depends_on = [aws_vpc_peering_connection.bird_to_jenkins]
  
}