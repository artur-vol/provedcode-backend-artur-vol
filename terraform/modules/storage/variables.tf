# Storage Module
# variables.tf


# S3 Bucket

variable "s3_bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow Terraform to delete bucket even if it contains objects"
  type        = bool
  default     = true
}


# IAM User

variable "user_name" {
  description = "IAM username for bucket access"
  type        = string
}


# IAM Policy

variable "policy_name" {
  description = "Name of the IAM policy for bucket access"
  type        = string
}


# SSM Parameter Store

variable "ssm_access_key_name" {
  description = "Name for storing IAM access key in SSM"
  type        = string
}

variable "ssm_access_key_description" {
  description = "Description for SSM parameter of IAM access key"
  type        = string
}

variable "ssm_secret_key_name" {
  description = "Name for storing IAM secret key in SSM"
  type        = string
}

variable "ssm_secret_key_description" {
  description = "Description for SSM parameter of IAM secret key"
  type        = string
}
