# variables.tf

# Provider

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-central-1" 
}

# VPC

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "provedcode-vpc"
}

# Internet Gateway

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
  default     = "my_igw"
}

# Public Subnet

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
  default     = "public_subnet"
}

# Private Subnets


variable "private_subnet_az_1" {
  description = "Availability Zone for the first private subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "private_subnet_az_2" {
  description = "Availability Zone for the second private subnet"
  type        = string
  default     = "eu-central-1b"
}

variable "private_subnet_cidr_block_1" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_block_2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}


variable "private_subnet_name" {
  description = "Name tag for the private subnet"
  type        = string
  default     = "private_subnet"
}

# Route Table
variable "public_route_table_name" {
  description = "Name tag for the public route table"
  type        = string
  default     = "public_route_table"
}

variable "private_route_table_name" {
  description = "Name tag for the private route table"
  type        = string
  default     = "private_route_table"
}


