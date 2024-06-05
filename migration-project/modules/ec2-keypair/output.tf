output "bastion_key_name" {
  value       = aws_key_pair.bakery_bastion_keypair.key_name
  description = "aws key pair name for bastion server"
}

output "web_key_name" {
  value       = aws_key_pair.bakery_web_keypair.key_name
  description = "aws key pair name for web server"
}