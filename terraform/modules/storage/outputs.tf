# Storage Module
# outputs.tf


# S3 Bucket

output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}


# IAM User Parameters

output "iam_user_name" {
  description = "IAM user created for bucket access"
  value       = aws_iam_user.this.name
}

output "iam_access_key_id" {
  description = "IAM access key ID"
  value       = aws_iam_access_key.this.id
}

output "iam_secret_key" {
  description = "IAM secret key"
  value       = aws_iam_access_key.this.secret
}
