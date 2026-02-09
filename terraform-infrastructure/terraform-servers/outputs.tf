output "private_ips" {
  description = "Internal IPs (assigned dynamically by AWS)"
  value = {
    for key, instance in aws_instance.instances :
    key => instance.private_ip
  }
}
output "loadbalancer_public_ip" {
  description = "Website URL (Wait for Nginx setup)"
  value       = "http://${aws_instance.lb.public_ip}"
}
