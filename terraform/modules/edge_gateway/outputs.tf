# Edge-Gateway Module
# outputs.tf


# Edge-Gateway Instance

output "edge_gateway_instance_id" {
  description = "ID of the edge-gateway EC2 instance"
  value       = aws_instance.edge_gateway.id
}

output "edge_gateway_public_ip" {
  description = "Public IP of the edge-gateway instance"
  value       = aws_instance.edge_gateway.public_ip
}

output "edge_gateway_private_ip" {
  description = "Private IP of the edge-gateway instance"
  value       = aws_instance.edge_gateway.private_ip
}


# Edge-Gateway Security Group

output "edge_gateway_sg_id" {
  description = "ID of the edge-gateway security group"
  value       = aws_security_group.edge_gateway.id
}


# Edge-Gateway SSH

output "edge_gateway_private_key" {
  description = "Private SSH key for edge_gateway instance (PEM format)"
  value       = tls_private_key.edge_gateway.private_key_openssh
  sensitive   = true
}

output "edge_gateway_public_key" {
  description = "Public SSH key for edge_gateway instance"
  value       = tls_private_key.edge_gateway.public_key_openssh
}

output "edge_gateway_key_pair_name" {
  description = "Name of the AWS EC2 key pair created for edge_gateway"
  value       = aws_key_pair.edge_gateway.key_name
}

output "edge_gateway_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter storing the private key"
  value       = aws_ssm_parameter.edge_gateway.name
}
