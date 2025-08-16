# Network Module
# outputs.tf


# Virtual Private Network
output "vpc_id" {
  value = aws_vpc.this.id
}

# Public Subnet
output "public_subnet_id" {
  value = aws_subnet.public.id
}

# Private Subnet
output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

# Private Route Table
output "private_route_table_id" {
  value = aws_route_table.private.id
}
