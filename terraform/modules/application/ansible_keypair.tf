resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ansible_key" {
  key_name   = "${var.env}_ansible_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "ansible_private_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "${var.env}_ansible_key"
  file_permission = "0600"
}
