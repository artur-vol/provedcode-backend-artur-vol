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
