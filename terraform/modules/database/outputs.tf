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
