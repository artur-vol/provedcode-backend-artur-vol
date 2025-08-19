# Frontend Module
# main.tf


# Frontend Security Group
resource "aws_security_group" "frontend" {
  name        = var.frontend_sg_name
  description = "Security group for frontend server"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = var.frontend_sg_revoke_rules

  tags = {
    Name = var.frontend_sg_name
  }
}

# Inbound Rules

# Allow HTTP traffic
resource "aws_security_group_rule" "frontend_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_http_cidrs
  description       = "Allow HTTP traffic"
  security_group_id = aws_security_group.frontend.id
}

# Allow HTTPS traffic
resource "aws_security_group_rule" "frontend_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_https_cidrs
  description       = "Allow HTTPS traffic"
  security_group_id = aws_security_group.frontend.id
}

# Allow SSH Access from Edge Gateway
resource "aws_security_group_rule" "frontend_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend.id
  description              = "Allow SSH access from Edge Gateway"
  source_security_group_id = var.edge_gateway_sg_id
}

# Allow Frontend App Traffic from Edge Gateway
resource "aws_security_group_rule" "frontend_from_edge_gateway" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend.id
  description              = "Allow Frontend app traffic from Edge Gateway"
  source_security_group_id = var.edge_gateway_sg_id
}

# Outbound Rules

# Allow all outbound traffic
resource "aws_security_group_rule" "frontend_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidrs
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.frontend.id
}

# SSH Key
resource "aws_key_pair" "frontend" {
  key_name   = var.frontend_key_pair_name
  public_key = file(var.frontend_public_key_path)
}

# EC2 Instance
resource "aws_instance" "frontend" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.frontend.id]
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.frontend.key_name

  tags = {
    Name = var.frontend_instance_name
  }
}
