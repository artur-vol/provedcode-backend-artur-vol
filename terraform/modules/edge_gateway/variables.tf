# Edge-Gateway Module
# variables.tf


# Virtual Private Network

variable "vpc_id" {
  description = "VPC ID where edge gateway will be deployed"
  type        = string
}


# Private Subnet

variable "subnet_id" {
  description = "Subnet ID for the edge gateway instance"
  type        = string
}

variable "private_subnet_cidr_block_1" {
  description = "CIDR block of first private subnet for NAT"
  type        = string
}

variable "private_subnet_cidr_block_2" {
  description = "CIDR block of second private subnet for NAT"
  type        = string
}


# Edge-Gateway Security Group

variable "edge_gateway_sg_name" {
  description = "Name for the edge-gateway security group"
  type        = string
}

variable "edge_gateway_sg_revoke_rules" {
  description = "Whether to revoke security group rules on delete"
  type        = bool
  default     = true
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed to access HTTP"
  type        = list(string)
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed to access HTTPS"
  type        = list(string)
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to access SSH"
  type        = list(string)
}


# Edge-Gateway Instance

variable "instance_ami" {
  description = "AMI ID for the edge-gateway instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for edge-gateway"
  type        = string
}

variable "edge_gateway_instance_name" {
  description = "Name tag for the edge-gateway EC2 instance"
  type        = string
}


# SSH

variable "edge_gateway_key_pair_name" {
  description = "Name of the SSH key pair for edge gateway"
  type        = string
}

variable "edge_gateway_ssh_private_key_ssm_name" {
  description = "Name of the SSM parameter to store the edge gateway private key"
  type        = string
}

variable "edge_gateway_public_key" {
  type        = string
  description = "Public SSH key for edge gateway"
}

variable "edge_gateway_private_key" {
  type        = string
  description = "Private SSH key for edge gateway"
  sensitive   = true
}


# Route

variable "private_route_table_id" {
  description = "ID of the private route table to associate NAT route"
  type        = string
}
