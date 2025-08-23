# Frontend Module
# outputs.tf


# Frontend EC2 Instance

output "frontend_instance_id" {
  description = "ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_private_ip" {
  description = "Private IP of the frontend instance"
  value       = aws_instance.frontend.private_ip
}


# Frontend Security Group

output "frontend_sg_id" {
  description = "ID of the frontend security group"
  value       = aws_security_group.frontend.id
}

# Frontend SSH

output "frontend_key_pair_name" {
  description = "Name of the AWS EC2 key pair created for frontend"
  value       = aws_key_pair.frontend.key_name
}

output "frontend_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter storing the private key"
  value       = aws_ssm_parameter.frontend.name
}
