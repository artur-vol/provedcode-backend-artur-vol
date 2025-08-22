# outputs.tf


# Network

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "private_subnet_cidr_block_1" {
  value = module.network.private_subnet_cidr_block_1
}

output "private_subnet_cidr_block_2" {
  value = module.network.private_subnet_cidr_block_2
}


# RDS

output "db_login" {
  description = "Database username for backend"
  value       = module.database.db_login
  sensitive   = true
}

output "db_password" {
  description = "Database password for backend"
  value       = module.database.db_password
  sensitive   = true
}

output "db_url" {
  description = "Database connection URL for backend"
  value       = module.database.db_url
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = module.database.db_endpoint
}


# S3

output "s3_access_key" {
  description = "S3 access key for backend"
  value       = module.storage.iam_access_key_id
}

output "s3_secret_key" {
  description = "S3 secret key for backend"
  value       = module.storage.iam_secret_key
  sensitive   = true
}

output "s3_region" {
  description = "S3 region"
  value       = module.storage.bucket_region
}

output "bucket" {
  description = "S3 bucket name"
  value       = module.storage.bucket_name
}


# Edge-Gateway

output "edge_gateway_public_ip" {
  description = "Public IP of the edge-gateway instance"
  value       = module.edge_gateway.edge_gateway_public_ip
}

output "edge_gateway_private_ip" {
  description = "Private IP of the edge-gateway instance"
  value       = module.edge_gateway.edge_gateway_private_ip
}

output "edge_gateway_private_key" {
  description = "Private SSH key for edge_gateway instance (PEM format)"
  value       = module.edge_gateway.edge_gateway_private_key
  sensitive   = true
}


# Backend

output "backend_private_ip" {
  description = "Private IP of the backend instance"
  value       = module.backend.backend_private_ip
}

output "backend_private_key" {
  description = "Private SSH key for backend instance (PEM format)"
  value       = module.backend.backend_private_key
  sensitive   = true
}


# Frontend

output "frontend_private_ip" {
  description = "Private IP of the frontend instance"
  value       = module.frontend.frontend_private_ip
}

output "frontend_private_key" {
  description = "Private SSH key for frontend instance (PEM format)"
  value       = module.frontend.frontend_private_key
  sensitive   = true
}


