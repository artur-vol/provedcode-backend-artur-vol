# variables.tf


# Network Module

# VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_dns_support" {
  description = "Enable DNS support in VPC"
  type        = bool
  default     = true
}

variable "vpc_dns_hostnames" {
  description = "Enable DNS hostnames in VPC"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "provedcode-vpc"
}

# Internet Gateway
variable "igw_name" {
  description = "Name for the Internet Gateway"
  type        = string
  default     = "provedcode-internet-gateway"
}

# Public Subnet
variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "map_public_ip" {
  description = "Map public IP on launch for public subnet"
  type        = bool
  default     = true
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
  default     = "public-subnet"
}

# Private Subnets
variable "private_subnet_az_1" {
  description = "Availability zone for the first private subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "private_subnet_az_2" {
  description = "Availability zone for the second private subnet"
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
  description = "Name tag for private subnets"
  type        = string
  default     = "private-subnet"
}

# Route Tables
variable "public_route_table_cidr" {
  description = "Destination CIDR for public route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_route_table_name" {
  description = "Name for the public route table"
  type        = string
  default     = "public-route-table"
}

variable "private_route_table_name" {
  description = "Name for the private route table"
  type        = string
  default     = "private-route-table"
}

# VPC Endpoint
variable "vpc_endpoint_service_name" {
  description = "Service name for VPC endpoint"
  type        = string
  default     = "com.amazonaws.eu-central-1.s3"
}

variable "vpc_endpoint_type" {
  description = "Type of the VPC endpoint"
  type        = string
  default     = "Gateway"
}


# Storage Module

# S3 Bucket
variable "s3_bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  default     = "provedcode-s3-bucket"
}

variable "force_destroy" {
  description = "Allow Terraform to delete bucket even if it contains objects"
  type        = bool
  default     = true
}

# IAM User
variable "storage_user_name" {
  description = "IAM username for bucket access"
  type        = string
  default     = "provedcode-s3-user"
}

# IAM Policy
variable "storage_policy_name" {
  description = "Name of the IAM policy for bucket access"
  type        = string
  default     = "provedcode-s3-policy"
}

# SSM Parameter Store
variable "ssm_access_key_name" {
  description = "Name for storing IAM access key in SSM"
  type        = string
  default     = "/provedcode/s3/access_key"
}

variable "ssm_access_key_description" {
  description = "Description for SSM parameter of IAM access key"
  type        = string
  default     = "Access key for S3 user"
}

variable "ssm_secret_key_name" {
  description = "Name for storing IAM secret key in SSM"
  type        = string
  default     = "/provedcode/s3/secret_key"
}

variable "ssm_secret_key_description" {
  description = "Description for SSM parameter of IAM secret key"
  type        = string
  default     = "Secret key for S3 user"
}


# Database Module

# Subnet Group
variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

# RDS configs
variable "db_engine" {
  description = "Database engine (e.g., postgres)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "17.5"
}

variable "db_identifier" {
  description = "Identifier for the DB instance"
  type        = string
  default     = "provedcode-database"
}

variable "db_instance_class" {
  description = "Instance class for the DB"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on deletion"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Whether to enable storage encryption"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Whether to apply modifications immediately"
  type        = bool
  default     = true
}


# Edge-Gateway Module 

variable "edge_vpc_id" {
  description = "VPC ID for the edge gateway"
  type        = string
}

variable "edge_subnet_id" {
  description = "Subnet ID for the edge gateway"
  type        = string
}

variable "edge_private_subnet_cidr_block_1" {
  description = "CIDR block of first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "edge_private_subnet_cidr_block_2" {
  description = "CIDR block of second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "edge_private_route_table_id" {
  description = "Private route table ID for NAT"
  type        = string
}

variable "edge_sg_name" {
  description = "Name of the edge gateway security group"
  type        = string
  default     = "edge-gateway-security-group"
}

variable "edge_sg_revoke_rules" {
  description = "Revoke security group rules on delete"
  type        = bool
  default     = true
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed for HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "CIDR blocks allowed for HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "edge_instance_ami" {
  description = "AMI for edge gateway EC2"
  type        = string
  default     = "ami-0a87a69d69fa289be"
}

variable "edge_instance_type" {
  description = "Instance type for edge gateway EC2"
  type        = string
  default     = "t3.micro"
}

variable "edge_instance_name" {
  description = "Name tag for edge gateway EC2"
  type        = string
  default     = "edge-gateway"
}

variable "edge_key_pair_name" {
  description = "SSH key pair name for edge gateway"
  type        = string
  default     = "edge-gateway-key"
}
