#create rsa key for bastion
resource "tls_private_key" "bakery_bastion_rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#create aws keypair for bastion
resource "aws_key_pair" "bakery_bastion_keypair" {
  key_name   = "${local.ClientName}-${var.EnvName}-ansible-${local.bastion_App}-Private-Key"
  public_key = tls_private_key.bakery_bastion_rsa_key.public_key_openssh
}

#download private key to local machine
resource "local_file" "bakery_bastion_key_download" {
  content  = tls_private_key.bakery_bastion_rsa_key.private_key_pem
  filename = "${local.ClientName}-${var.EnvName}-ansible-${local.bastion_App}-Private-Key.pem"
}

#create rsa key for web
resource "tls_private_key" "bakery_web_rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#create aws keypair for web
resource "aws_key_pair" "bakery_web_keypair" {
  key_name   = "${local.ClientName}-${var.EnvName}-${local.web_App}-Private-Key"
  public_key = tls_private_key.bakery_bastion_rsa_key.public_key_openssh
}

#download private key to local machine
resource "local_file" "bakery_web_key_download" {
  content  = tls_private_key.bakery_web_rsa_key.private_key_pem
  filename = "${local.ClientName}-${var.EnvName}-${local.web_App}-Private-Key.pem"
}