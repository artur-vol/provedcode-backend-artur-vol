# Network Module
# main.tf


# Virtual Private Network

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_dns_support" {
  description = "Enable or disable DNS support in the VPC"
  type        = bool
}

variable "vpc_dns_hostnames" {
  description = "Enable or disable DNS hostnames in the VPC"
  type        = bool
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}


# Internet Gateway

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}


# Public Subnet

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_subnet_az" {
  description = "Availability Zone for the public subnet"
  type        = string
}

variable "map_public_ip" {
  description = "Assign public IPs in subnet"
  type        = bool
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
}


# Private Subnet

variable "private_subnet_az_1" {
  description = "Availability Zone for the first private subnet"
  type        = string
}

variable "private_subnet_az_2" {
  description = "Availability Zone for the second private subnet"
  type        = string
}

variable "private_subnet_cidr_block_1" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_cidr_block_2" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name tag for the private subnet"
  type        = string
}


# Public Route Table

variable "public_route_table_cidr" {
  description = "0.0.0.0/0"
  type        = string
}

variable "public_route_table_name" {
  description = "Name tag for the public route table"
  type        = string
}


# Private Route Table

variable "private_route_table_name" {
  description = "Name tag for the private route table"
  type        = string
}

