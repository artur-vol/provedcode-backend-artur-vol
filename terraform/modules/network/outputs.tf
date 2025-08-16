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

# Database Group Subnet Name
output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}

# Private Subnet 1 CIDR
output "private_subnet_cidr_block_1" {
  value = aws_subnet.private_1.cidr_block
}

# Private Subnet 2 CIDR
output "private_subnet_cidr_block_2" {
  value = aws_subnet.private_2.cidr_block
}

# Private Subnet CIDRs
output "private_subnet_cidrs" {
  value = [
    aws_subnet.private_1.cidr_block,
    aws_subnet.private_2.cidr_block
  ]
}
