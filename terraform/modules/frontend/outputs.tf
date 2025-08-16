# Frontend Module
# outputs.tf


# EC2 Instance

output "frontend_instance_id" {
  description = "ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_private_ip" {
  description = "Private IP of the frontend instance"
  value       = aws_instance.frontend.private_ip
}


# Security Group

output "frontend_sg_id" {
  description = "ID of the frontend security group"
  value       = aws_security_group.frontend.id
}
