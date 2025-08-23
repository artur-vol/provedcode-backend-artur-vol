# Backend Module
# variables.tf


# Virtual Private Network

variable "vpc_id" {
  description = "VPC ID where backend will be deployed"
  type        = string
}


# Subnet

variable "subnet_id" {
  description = "Subnet ID for the backend instance"
  type        = string
}


# Frontend Security Group

variable "frontend_sg_id" {
  description = "Security Group ID of the frontend to allow access"
  type        = string
}


# Edge-Gateway Instance

variable "edge_gateway_sg_id" {
  description = "Security Group ID of the edge gateway for SSH access"
  type        = string
}


# Backend Security Group

variable "backend_sg_name" {
  description = "Name for the backend security group"
  type        = string
}

variable "backend_sg_revoke_rules" {
  description = "Whether to revoke security group rules on delete"
  type        = bool
  default     = true
}

variable "egress_cidrs" {
  description = "List of CIDR blocks allowed for egress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


# SSH

variable "backend_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter to store the backend private key"
  type        = string
}

variable "backend_key_pair_name" {
  description = "Name of the SSH key pair for backend"
  type        = string
}

variable "backend_public_key" {
  type        = string
  description = "Public SSH key for backend"
}

variable "backend_private_key" {
  type        = string
  description = "Private SSH key for backend"
  sensitive   = true
}


# Backend EC2 Instance

variable "instance_ami" {
  description = "AMI ID for the backend instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for backend"
  type        = string
}

variable "backend_instance_name" {
  description = "Name tag for the backend EC2 instance"
  type        = string
}
