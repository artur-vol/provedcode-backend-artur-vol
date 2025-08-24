# Backend Module
# main.tf


# Backend Security Group
resource "aws_security_group" "backend" {
  name        = var.backend_sg_name
  description = "Security group for backend server"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = var.backend_sg_revoke_rules

  tags = {
    Name = var.backend_sg_name
  }
}

# Inbound rules

# Allow access from frontend SG
resource "aws_security_group_rule" "backend_from_frontend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  description              = "Allow Backend access from Frontend Security Group"
  source_security_group_id = var.frontend_sg_id
}

# Allow SSH from Edge Gateway
resource "aws_security_group_rule" "backend_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  description              = "Allow SSH access from Edge Gateway Security Group"
  source_security_group_id = var.edge_gateway_sg_id
}

# Allow backend access from Edge Gateway
resource "aws_security_group_rule" "backend_from_edge_gateway" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  description              = "Allow Backend access from Edge Gateway Security Group"
  source_security_group_id = var.edge_gateway_sg_id
}

# Outbound rules

# Allow all outbound traffic
resource "aws_security_group_rule" "backend_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidrs
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.backend.id
}

# SSH Key
resource "aws_key_pair" "backend" {
  key_name   = var.backend_key_pair_name
  public_key = var.backend_public_key
}

resource "aws_ssm_parameter" "backend" {
  name        = var.backend_ssh_private_key_ssm_name
  description = "Private SSH key for backend EC2 instance"
  type        = "SecureString"
  value       = var.backend_private_key
  tier        = "Standard"

  lifecycle {
    ignore_changes = [value]
  }
}

# EC2 Instance
resource "aws_instance" "backend" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.backend.id]
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.backend.key_name

  tags = {
    Name = var.backend_instance_name
  }
}
