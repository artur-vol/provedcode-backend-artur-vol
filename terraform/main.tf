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

  vpc_cidr_block   = var.vpc_cidr_block
  vpc_dns_support  = var.vpc_dns_support
  vpc_dns_hostnames = var.vpc_dns_hostnames
  vpc_name         = var.vpc_name

  igw_name = var.igw_name

  public_subnet_cidr_block = var.public_subnet_cidr_block
  public_subnet_az         = var.public_subnet_az
  map_public_ip            = var.map_public_ip
  public_subnet_name       = var.public_subnet_name

  private_subnet_az_1       = var.private_subnet_az_1
  private_subnet_az_2       = var.private_subnet_az_2
  private_subnet_cidr_block_1 = var.private_subnet_cidr_block_1
  private_subnet_cidr_block_2 = var.private_subnet_cidr_block_2
  private_subnet_name       = var.private_subnet_name

  public_route_table_cidr  = var.public_route_table_cidr
  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name

  vpc_endpoint_service_name = var.vpc_endpoint_service_name
  vpc_endpoint_type         = var.vpc_endpoint_type
}


# storage

module "storage" {
  source = "./modules/storage"

  s3_bucket_name = var.s3_bucket_name
  force_destroy  = var.force_destroy

  user_name = var.storage_user_name
  policy_name = var.storage_policy_name

  ssm_access_key_name        = var.ssm_access_key_name
  ssm_access_key_description = var.ssm_access_key_description
  ssm_secret_key_name        = var.ssm_secret_key_name
  ssm_secret_key_description = var.ssm_secret_key_description
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


