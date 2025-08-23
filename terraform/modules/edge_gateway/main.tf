# Edge-Gateway Module
# main.tf


# Edge-Gateway Security Group
resource "aws_security_group" "edge_gateway" {
  name        = var.edge_gateway_sg_name
  description = "Security group for edge-gateway server"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = var.edge_gateway_sg_revoke_rules

  tags = {
    Name = var.edge_gateway_sg_name
  }
}

# Allow HTTP traffic
resource "aws_security_group_rule" "edge_gateway_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_http_cidrs
  description       = "Allow HTTP traffic"
  security_group_id = aws_security_group.edge_gateway.id
}

# Allow HTTPS traffic
resource "aws_security_group_rule" "edge_gateway_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_https_cidrs
  description       = "Allow HTTPS traffic"
  security_group_id = aws_security_group.edge_gateway.id
}

# Allow SSH
resource "aws_security_group_rule" "edge_gateway_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  description       = "Allow SSH access"
  security_group_id = aws_security_group.edge_gateway.id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "edge_gateway_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.edge_gateway.id
}

# Allow all traffic from private subnets for NAT
resource "aws_security_group_rule" "edge_gateway_nat_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.edge_gateway.id
  cidr_blocks       = [var.private_subnet_cidr_block_1, var.private_subnet_cidr_block_2]
  description       = "Allow all traffic from private subnets for NAT"
}

# EC2 Edge-Gateway Instance
resource "aws_instance" "edge_gateway" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  source_dest_check           = false
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.edge_gateway.id]
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.edge_gateway.key_name

  tags = {
    Name = var.edge_gateway_instance_name
  }

  # user_data = file("${path.module}/nat_setup.sh")
  depends_on = [aws_key_pair.edge_gateway]
}

# SSH Key
resource "tls_private_key" "edge_gateway" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "edge_gateway" {
  key_name   = var.edge_gateway_key_pair_name
  public_key = tls_private_key.edge_gateway.public_key_openssh
}

resource "aws_ssm_parameter" "edge_gateway" {
  name        = var.edge_gateway_ssh_private_key_ssm_name
  description = "Private SSH key for edge gateway EC2 instance"
  type        = "SecureString"
  value       = tls_private_key.edge_gateway.private_key_openssh
}

# Edge-Gateway Route
resource "aws_route" "private_nat" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.edge_gateway.primary_network_interface_id
}

