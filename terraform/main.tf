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

  backend "s3" {
    bucket = "remote-tfstate-storage-3da99298c85f82d4"
    key    = "provedcode/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}


# network

module "network" {
  source = "./modules/network"

  vpc_cidr_block    = var.vpc_cidr_block
  vpc_dns_support   = var.vpc_dns_support
  vpc_dns_hostnames = var.vpc_dns_hostnames
  vpc_name          = var.vpc_name

  igw_name = var.igw_name

  public_subnet_cidr_block = var.public_subnet_cidr_block
  public_subnet_az         = var.public_subnet_az
  map_public_ip            = var.map_public_ip
  public_subnet_name       = var.public_subnet_name

  private_subnet_az_1         = var.private_subnet_az_1
  private_subnet_az_2         = var.private_subnet_az_2
  private_subnet_cidr_block_1 = var.private_subnet_cidr_block_1
  private_subnet_cidr_block_2 = var.private_subnet_cidr_block_2
  private_subnet_name         = var.private_subnet_name

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

  user_name   = var.storage_user_name
  policy_name = var.storage_policy_name

  ssm_access_key_name        = var.ssm_access_key_name
  ssm_access_key_description = var.ssm_access_key_description
  ssm_secret_key_name        = var.ssm_secret_key_name
  ssm_secret_key_description = var.ssm_secret_key_description
}


# database

module "database" {
  source = "./modules/database"

  vpc_id               = module.network.vpc_id
  db_subnet_group_name = module.network.db_subnet_group_name

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_identifier     = var.db_identifier
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password

  db_allocated_storage = var.db_allocated_storage
  skip_final_snapshot  = var.skip_final_snapshot
  storage_encrypted    = var.storage_encrypted
  apply_immediately    = var.apply_immediately

  db_sg_name    = var.db_sg_name
  backend_sg_id = module.backend.backend_sg_id
}


# edge-gateway

module "edge_gateway" {
  source = "./modules/edge_gateway"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_id

  private_subnet_cidr_block_1 = module.network.private_subnet_cidrs[0]
  private_subnet_cidr_block_2 = module.network.private_subnet_cidrs[1]
  private_route_table_id      = module.network.private_route_table_id

  edge_gateway_sg_name         = var.edge_sg_name
  edge_gateway_sg_revoke_rules = var.edge_sg_revoke_rules
  allowed_http_cidrs           = var.allowed_http_cidrs
  allowed_https_cidrs          = var.allowed_https_cidrs
  allowed_ssh_cidrs            = var.allowed_ssh_cidrs

  instance_ami               = var.edge_instance_ami
  instance_type              = var.edge_instance_type
  edge_gateway_instance_name = var.edge_instance_name

  edge_gateway_key_pair_name   = var.edge_key_pair_name
  edge_gateway_public_key_path = var.edge_gateway_public_key_path
}


# frontend
module "frontend" {
  source = "./modules/frontend"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.private_subnet_ids[0]

  edge_gateway_sg_id = module.edge_gateway.edge_gateway_sg_id

  frontend_sg_name         = var.frontend_sg_name
  frontend_sg_revoke_rules = var.frontend_sg_revoke_rules
  allowed_http_cidrs       = var.allowed_http_cidrs
  allowed_https_cidrs      = var.allowed_https_cidrs

  frontend_key_pair_name   = var.frontend_key_pair_name
  frontend_public_key_path = var.frontend_public_key_path

  instance_ami           = var.frontend_instance_ami
  instance_type          = var.frontend_instance_type
  frontend_instance_name = var.frontend_instance_name
}


# backend

module "backend" {
  source = "./modules/backend"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.private_subnet_ids[0]

  edge_gateway_sg_id = module.edge_gateway.edge_gateway_sg_id
  frontend_sg_id     = module.frontend.frontend_sg_id

  backend_sg_name         = var.backend_sg_name
  backend_sg_revoke_rules = var.backend_sg_revoke_rules

  backend_key_pair_name   = var.backend_key_pair_name
  backend_public_key_path = var.backend_public_key_path

  instance_ami          = var.backend_instance_ami
  instance_type         = var.backend_instance_type
  backend_instance_name = var.backend_instance_name
}

