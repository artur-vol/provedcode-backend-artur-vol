# Backend Module
# outputs.tf


# Backend Instance

output "backend_instance_id" {
  description = "ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_private_ip" {
  description = "Private IP of the backend instance"
  value       = aws_instance.backend.private_ip
}


# Backend Security Group

output "backend_sg_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}


# Backend SSH

output "backend_key_pair_name" {
  description = "Name of the AWS EC2 key pair created for backend"
  value       = aws_key_pair.backend.key_name
}

output "backend_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter storing the private key"
  value       = aws_ssm_parameter.backend.name
}
