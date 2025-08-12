# main.tf

terraform {
  required_version = ">= 1.1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
}

provider "aws" {
  region = var.region
}


# =======================
# ======= NETWORK =======
# =======================

# Virtual Private Network
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.igw_name
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_name
  }
}

# Private Subnet_1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_block_1
  availability_zone = var.private_subnet_az_1

  tags = {
    Name = "${var.private_subnet_name}-1"
  }
}

# Private Subnet_2
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_block_2
  availability_zone = var.private_subnet_az_2

  tags = {
    Name = "${var.private_subnet_name}-2"
  }
}

# Private Subnet Group
resource "aws_db_subnet_group" "this" {
  name = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]

  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}


# Public Subnet Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# Private Subnets Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.private_route_table_name
  }
}

# Public Subnet and Route Table Association
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Subnet_1 and Route Table Association
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

# Private Subnet_2 and Route Table Association
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}


# =======================
# ======= COMPUTE =======
# =======================

# EC2 Instance
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.frontend.id]
  subnet_id              = aws_subnet.private_1.id
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = var.frontend_instance_name
  }
}

# EC2 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = [var.virtualization_type]
  }

  owners = [var.ami_owner]
}

# Frontend Security Group
resource "aws_security_group" "frontend" {
  name        = var.frontend_sg_name
  description = "Security group for frontend server"
  vpc_id      = aws_vpc.this.id

  revoke_rules_on_delete = true

  tags = {
    Name = var.frontend_sg_name
  }
}

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

# Allow SSH
resource "aws_security_group_rule" "frontend_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  description       = "Allow SSH access"
  security_group_id = aws_security_group.frontend.id
}

# Allow all outbound traffic
resource "aws_security_group_rule" "frontend_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.frontend.id
}

# EC2 Backend
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.backend.id]
  subnet_id              = aws_subnet.private_1.id
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = var.backend_instance_name
  }
}

# Backend Security Group
resource "aws_security_group" "backend" {
  name        = var.backend_sg_name
  description = "Security group for backend server"
  vpc_id      = aws_vpc.this.id

  revoke_rules_on_delete = true

  tags = {
    Name = var.backend_sg_name
  }
}

# Allow access from frontend SG
resource "aws_security_group_rule" "backend_from_frontend" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  description              = "Allow backend access from frontend SG"
  source_security_group_id = aws_security_group.frontend.id
}

# Allow SSH
resource "aws_security_group_rule" "backend_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  security_group_id = aws_security_group.backend.id
  description       = "Allow SSH access"
}

# Allow all outbound traffic
resource "aws_security_group_rule" "backend_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend.id
  description       = "Allow all outbound traffic"
}

# SSH Key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}


# =======================
# ======= STORAGE =======
# =======================


# Random Values Generator
resource "random_id" "this" {
  byte_length = 8
}

# S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket = "${var.s3_bucket_name}-${random_id.this.hex}"

  force_destroy = true

}

# Block public access
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM User with S3 Bucket access
resource "aws_iam_user" "this" {
  name = var.user_name
}


# Credentials for IAM User
resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_policy" "this" {
  name = var.policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Statement1",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}

# Policy and IAM User Association
resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}

# S3 Bucket User Secret Key
resource "aws_ssm_parameter" "secret_key" {
  name        = var.ssm_secret_key_name
  description = var.ssm_secret_key_description
  type        = "SecureString"
  value       = aws_iam_access_key.this.secret
  tier        = "Standard"
}

# S3 Bucket User Access Key
resource "aws_ssm_parameter" "access_key" {
  name        = var.ssm_access_key_name
  description = var.ssm_access_key_description
  type        = "SecureString"
  value       = aws_iam_access_key.this.id
  tier        = "Standard"
}
