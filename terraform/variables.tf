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

# VPC Endpoint
variable "vpc_endpoint_service_name" {
  description = ""
  type        = string
  default     = "com.amazonaws.eu-central-1.s3"
}

# EC2 Frontend

variable "frontend_instance_name" {
  description = "Name tag for the frontend EC2 instance"
  type        = string
  default     = "frontend"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# EC2 Backend
variable "backend_instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "backend"
}


# AMI

variable "ami_name_filter" {
  description = "AMI name filter pattern"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "virtualization_type" {
  description = "Virtualization type filter for AMI"
  type        = string
  default     = "hvm"
}

variable "ami_owner" {
  description = "Owner ID of the AMI"
  type        = string
  default     = "099720109477" # Canonicals
}

# Security Groups

variable "frontend_sg_name" {
  description = "The name of the frontend Security Group"
  type        = string
  default     = "frontend-sg"
}

variable "allowed_http_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks allowed for HTTP traffic (port 80)"
}

variable "allowed_https_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDR blocks allowed for HTTPS traffic (port 443)"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  default     = ["178.212.243.25/32"]
  description = "List of CIDR blocks allowed for SSH access (port 22)"
}

variable "backend_sg_name" {
  type        = string
  default     = "backend_sg"
  description = "Name of the Security Group for backend servers"
}

# Access Key
variable "key_pair_name" {
  type        = string
  default     = "deployer-key"
  description = "Name of the SSH key pair for instance access"
}

# S3 Bucket
variable "s3_bucket_name" {
  description = "Name tag for the S3 Bucket (should be unique)"
  type        = string
  default     = "provedcode-s3-bucket"
}

# IAM User
variable "user_name" {
  description = "Name tag for the backend user"
  type        = string
  default     = "backend_s3_user"
}

# IAM Policy
variable "policy_name" {
  description = "Name tag for the IAM Policy"
  type        = string
  default     = "s3_bucket_access"
}

# SSM Parameters
variable "ssm_secret_key_name" {
  description = "Name for the SSM parameter storing the secret access key"
  type        = string
  default     = "/myapp/s3/secret_access_key"
}

variable "ssm_secret_key_description" {
  description = "Description for the SSM parameter storing the secret access key"
  type        = string
  default     = "Provide an access to the S3 Bucket"
}

variable "ssm_access_key_name" {
  description = "Name for the SSM parameter storing the access key id"
  type        = string
  default     = "/myapp/s3/access_key_id"
}

variable "ssm_access_key_description" {
  description = "Description for the SSM parameter storing the access key id"
  type        = string
  default     = "Provide an access to the S3 Bucket"
}



