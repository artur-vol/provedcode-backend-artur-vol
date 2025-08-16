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


# network

module "network" {
  source = "./modules/network"

  # VPC
  vpc_cidr_block   = "10.0.0.0/16"
  vpc_dns_support  = true
  vpc_dns_hostnames = true
  vpc_name         = "provedcode-vpc"

  # Internet Gateway
  igw_name = "provedcode-internet-gateway"

  # Public Subnet
  public_subnet_cidr_block = "10.0.1.0/24"
  public_subnet_az         = "eu-central-1a"
  map_public_ip            = true
  public_subnet_name       = "public-subnet"

  # Private Subnets
  private_subnet_az_1       = "eu-central-1a"
  private_subnet_az_2       = "eu-central-1b"
  private_subnet_cidr_block_1 = "10.0.2.0/24"
  private_subnet_cidr_block_2 = "10.0.3.0/24"
  private_subnet_name       = "private-subnet"

  # Route Tables
  public_route_table_cidr  = "0.0.0.0/0"
  public_route_table_name  = "public-route-table"
  private_route_table_name = "private-route-table"

  # VPC Endpoint
  vpc_endpoint_service_name = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type         = "Gateway"
}


# storage

module "storage" {
  source = "./modules/storage"

  # S3 Bucket
  s3_bucket_name = "provedcode-s3-bucket"
  force_destroy  = true

  # IAM User
  user_name = "provedcode-s3-user"

  # IAM Policy
  policy_name = "provedcode-s3-policy"

  # SSM Parameters
  ssm_access_key_name        = "/provedcode/s3/access_key"
  ssm_access_key_description = "Access key for S3 user"
  ssm_secret_key_name        = "/provedcode/s3/secret_key"
  ssm_secret_key_description = "Secret key for S3 user"
}


# database

module "database" {
  source = "./modules/database"

  # Subnet Group
  db_subnet_group_name = module.network.db_subnet_group_name

  # RDS configs
  db_engine         = "postgres"
  db_engine_version = "17.5"
  db_identifier     = "provedcode-database"
  db_instance_class = "db.t4g.micro"
  db_username       = "change me!!!"
  db_password       = "change me!!!"

  db_allocated_storage = 20
  skip_final_snapshot  = true
  storage_encrypted    = false
  apply_immediately    = true
}


# edge-gateway

module "edge_gateway" {
  source = "./modules/edge_gateway"

  # VPC and Subnet
  vpc_id  = module.network.vpc_id
  subnet_id = module.network.public_subnet_id

  # NAT Private subnets CIDR
  private_subnet_cidr_block_1 = "10.0.2.0/24"
  private_subnet_cidr_block_2 = "10.0.3.0/24"
  private_route_table_id      = module.network.private_route_table_id

  # Security Group
  edge_gateway_sg_name        = "edge-gateway-security-group"
  edge_gateway_sg_revoke_rules = true
  allowed_http_cidrs          = ["0.0.0.0/0"]
  allowed_https_cidrs         = ["0.0.0.0/0"]
  allowed_ssh_cidrs           = ["178.212.243.25/32"]

  # EC2 Instance
  instance_ami                = "ami-0a87a69d69fa289be"
  instance_type               = "t3.micro"
  edge_gateway_instance_name  = "edge-gateway"

  # SSH Key
  edge_gateway_key_pair_name  = "edge-gateway-key"
  edge_gateway_public_key_path = "/Users/arturvolinec/vsyake/soft-serve/devops-project-level/provedcode-backend-artur-vol/terraform/keys/edge-gateway.pub"
}

# frontend

module "frontend" {
  source = "./modules/frontend"

  # VPC і Subnet
  vpc_id   = module.network.vpc_id
  subnet_id = module.network.private_subnet_ids[0]

  # SSH Edge-Gateway Security Group
  edge_gateway_sg_id = module.edge_gateway.edge_gateway_sg_id

  # Security Group
  frontend_sg_name        = "frontend-security-group"
  frontend_sg_revoke_rules = true
  allowed_http_cidrs       = ["0.0.0.0/0"]
  allowed_https_cidrs      = ["0.0.0.0/0"]
  egress_cidrs             = ["0.0.0.0/0"]

  # SSH Key
  frontend_key_pair_name  = "frontend-key"
  frontend_public_key_path = "/Users/arturvolinec/vsyake/soft-serve/devops-project-level/provedcode-backend-artur-vol/terraform/keys/frontend.pub"

  # EC2 Instance
  instance_ami           = "ami-0a87a69d69fa289be"
  instance_type          = "t3.micro"
  frontend_instance_name = "frontend"
}

# backend

module "backend" {
  source = "./modules/backend"
  
  # VPC і Subnet
  vpc_id   = module.network.vpc_id
  subnet_id = module.network.private_subnet_ids[0]

  # SSH Edge-Gateway Security Group
  edge_gateway_sg_id = module.edge_gateway.edge_gateway_sg_id
  frontend_sg_id = module.frontend.frontend_sg_id

  # Security Group
  backend_sg_name        = "backend-security-group"
  backend_sg_revoke_rules = true
  egress_cidrs             = ["0.0.0.0/0"]

  # SSH Key
  backend_key_pair_name  = "backend-key"
  backend_public_key_path = "/Users/arturvolinec/vsyake/soft-serve/devops-project-level/provedcode-backend-artur-vol/terraform/keys/backend.pub"

  # EC2 Instance
  instance_ami           = "ami-0a87a69d69fa289be"
  instance_type          = "t3.micro"
  backend_instance_name = "backend"
}


