# Database Module
# main.tf


# RDS
resource "aws_db_instance" "this" {
  allocated_storage      = var.db_allocated_storage
  db_subnet_group_name   = var.db_subnet_group_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  identifier             = var.db_identifier
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = var.skip_final_snapshot
  storage_encrypted      = var.storage_encrypted
  apply_immediately      = var.apply_immediately
  vpc_security_group_ids = [aws_security_group.database.id]
}

# RDS Security Group
resource "aws_security_group" "database" {
  name        = var.database_sg_name
  description = "Security group for database server"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.database_sg_name
  }
}

# Allow Access from Backend Security Group
resource "aws_security_group_rule" "database_from_backend" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database.id
  description              = "Allow Database Access from Backend Security Group"
  source_security_group_id = var.backend_sg_id
}
