output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "private_subnet_route_table_id" {
  value = aws_route_table.private_subnet.id
}

output "public_subnet_route_table_id" {
  value = aws_route_table.public_subnet.id
}