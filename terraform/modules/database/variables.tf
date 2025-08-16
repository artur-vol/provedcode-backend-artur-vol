# Database Module
# variables.tf


# RDS

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "db_engine" {
  description = "Database engine (e.g., postgres)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_identifier" {
  description = "Identifier for the DB instance"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the DB"
  type        = string
}

variable "db_username" {
  description = "Master username for the DB"
  type        = string
}

variable "db_password" {
  description = "Master password for the DB"
  type        = string
  sensitive   = true
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
