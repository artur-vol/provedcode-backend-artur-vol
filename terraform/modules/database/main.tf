# Database Module
# main.tf


resource "aws_db_instance" "this" {
  allocated_storage    = var.db_allocated_storage
  db_subnet_group_name = var.db_subnet_group_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  identifier           = var.db_identifier
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  skip_final_snapshot  = var.skip_final_snapshot
  storage_encrypted    = var.storage_encrypted
  apply_immediately    = var.apply_immediately
}
