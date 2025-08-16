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
