resource "aws_security_group" "loadbalancer" {
  name        = "loadbalancer"
  description = "Allow HTTPS/HTTP inbound traffic, inbound traffic needed for configuration and all outbound traffic"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.env}-${var.project}-loadbalancer-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_https" {
  description       = "Allow HTTPS inbound traffic from all internet users"
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_http" {
  description       = "Allow HTTP inbound traffic from all internet users"
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_consul_lan_serf_tcp" {
  description                  = "Allow inbound traffic for Consul Serf local area network port (TCP)"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 8301
  ip_protocol                  = "tcp"
  to_port                      = 8301
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_consul_lan_serf_udp" {
  description                  = "Allow inbound traffic for Consul Serf local area network port (UDP)"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 8301
  ip_protocol                  = "udp"
  to_port                      = 8301
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_consul_dns_tcp" {
  description                  = "Allow inbound traffic for Consul DNS server (TCP)"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 8600
  ip_protocol                  = "tcp"
  to_port                      = 8600
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_consul_dns_udp" {
  description                  = "Allow inbound traffic for Consul DNS server (UDP)"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 8600
  ip_protocol                  = "udp"
  to_port                      = 8600
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_ssh" {
  description                  = "Allow SSH connection needed for Ansible configuration"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_node_exporter" {
  description                  = "Allow inbound traffic for Node Exporter"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 9100
  ip_protocol                  = "tcp"
  to_port                      = 9100
}

resource "aws_vpc_security_group_ingress_rule" "loadbalancer_allow_prometheus" {
  description                  = "Allow inbound traffic for Prometheus"
  security_group_id            = aws_security_group.loadbalancer.id
  referenced_security_group_id = aws_security_group.internal_services.id
  from_port                    = 8500
  ip_protocol                  = "tcp"
  to_port                      = 8500
}

resource "aws_vpc_security_group_egress_rule" "loadbalancer_allow_all_traffic_ipv4" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.loadbalancer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



resource "aws_security_group" "internal_services" {
  name        = "internal_services"
  description = "Security group for instances in the private subnet"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.env}-${var.project}-internal-services-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_self" {
  description                  = "Allow inbound traffic over any port from instances in the same security group"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.internal_services.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_loadbalancer_http_tcp" {
  description                  = "Allow HTTP traffic from loadbalancer"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.loadbalancer.id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_consul_dns_tcp" {
  description                  = "Allow inbound traffic for Consul DNS server (TCP)"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.loadbalancer.id
  from_port                    = 8600
  ip_protocol                  = "tcp"
  to_port                      = 8600
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_consul_dns_udp" {
  description                  = "Allow inbound traffic for Consul DNS server (UDP)"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.loadbalancer.id
  from_port                    = 8600
  ip_protocol                  = "udp"
  to_port                      = 8600
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_consul_rpc" {
  description                  = "Allow Consul internal communication from loadbalancer"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.loadbalancer.id
  from_port                    = 8300
  to_port                      = 8300
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_service_discovery_tcp" {
  description                  = "Allow service discovery traffic from loadbalancer (TCP)"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.loadbalancer.id
  from_port                    = 8301
  ip_protocol                  = "tcp"
  to_port                      = 8301
}

resource "aws_vpc_security_group_ingress_rule" "internal_services_allow_service_discovery_udp" {
  description                  = "Allow service discovery traffic from loadbalancer (UDP)"
  security_group_id            = aws_security_group.internal_services.id
  referenced_security_group_id = aws_security_group.loadbalancer.id
  from_port                    = 8301
  ip_protocol                  = "udp"
  to_port                      = 8301
}

resource "aws_vpc_security_group_egress_rule" "internal_services_allow_all_traffic_ipv4" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.internal_services.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
