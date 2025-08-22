# Backend Module
# outputs.tf


# EC2 Instance

output "backend_instance_id" {
  description = "ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_private_ip" {
  description = "Private IP of the backend instance"
  value       = aws_instance.backend.private_ip
}


# Security Group

output "backend_sg_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}


# SSH

output "backend_private_key" {
  description = "Private SSH key for backend instance (PEM format)"
  value       = tls_private_key.backend.private_key_openssh
  sensitive   = true
}

output "backend_public_key" {
  description = "Public SSH key for backend instance"
  value       = tls_private_key.backend.public_key_openssh
}

output "backend_key_pair_name" {
  description = "Name of the AWS EC2 key pair created for backend"
  value       = aws_key_pair.backend.key_name
}

output "backend_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter storing the private key"
  value       = aws_ssm_parameter.backend.name
}
