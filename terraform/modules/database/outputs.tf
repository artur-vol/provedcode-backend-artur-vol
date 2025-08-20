# Database Module
# outputs.tf


# RDS

output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the initial database"
  value       = aws_db_instance.this.db_name
}

output "db_login" {
  description = "Master username for the RDS instance"
  value       = aws_db_instance.this.username
}

output "db_password" {
  description = "Master password for the RDS instance"
  value       = aws_db_instance.this.password
  sensitive   = true
}

output "db_url" {
  description = "JDBC URL to connect to the database"
  value       = "jdbc:postgresql://${aws_db_instance.this.endpoint}:${aws_db_instance.this.port}/${aws_db_instance.this.db_name}"
}

