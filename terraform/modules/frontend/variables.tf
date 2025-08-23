# Frontend Module
# variables.tf


# Virtual Private Network

variable "vpc_id" {
  description = "VPC ID where frontend will be deployed"
  type        = string
}


# Private Subnet

variable "subnet_id" {
  description = "Subnet ID for the frontend instance"
  type        = string
}


# Edge-Gateway Security Group

variable "edge_gateway_sg_id" {
  description = "Security Group ID of the edge gateway for SSH access"
  type        = string
}


# Security Group

variable "frontend_sg_name" {
  description = "Name for the frontend security group"
  type        = string
}

variable "frontend_sg_revoke_rules" {
  description = "Whether to revoke security group rules on delete"
  type        = bool
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed to access HTTP"
  type        = list(string)
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed to access HTTPS"
  type        = list(string)
}

variable "egress_cidrs" {
  description = "List of CIDR blocks allowed for egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


# SSH

variable "frontend_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter to store the frontend private key"
  type        = string
}

variable "frontend_key_pair_name" {
  description = "Name of the SSH key pair for frontend"
  type        = string
}

variable "frontend_public_key" {
  type        = string
  description = "Public SSH key for frontend"
  sensitive   = true
}

variable "frontend_private_key" {
  type        = string
  description = "Private SSH key for frontend"
  sensitive   = true
}


# EC2 Instance 

variable "instance_ami" {
  description = "AMI ID for the frontend instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for frontend"
  type        = string
}

variable "frontend_instance_name" {
  description = "Name tag for the frontend EC2 instance"
  type        = string
}
