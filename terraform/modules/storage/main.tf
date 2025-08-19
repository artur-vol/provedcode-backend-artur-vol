# Storage Module
# main.tf


# Random ID for bucket uniqueness
resource "random_id" "this" {
  byte_length = 8
}

# S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket        = "${var.s3_bucket_name}-${random_id.this.hex}"
  force_destroy = var.force_destroy

  tags = {
    Name = "${var.s3_bucket_name}-${random_id.this.hex}"
  }
}

# IAM User for bucket access
resource "aws_iam_user" "this" {
  name = var.user_name
}

# IAM Access Key for the user
resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

# Policy granting access to the bucket
resource "aws_iam_policy" "this" {
  name = var.policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Statement1",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}

# Store user's keys in Parameter Store
resource "aws_ssm_parameter" "access_key" {
  name        = var.ssm_access_key_name
  description = var.ssm_access_key_description
  type        = "SecureString"
  value       = aws_iam_access_key.this.id
  tier        = "Standard"
}

resource "aws_ssm_parameter" "secret_key" {
  name        = var.ssm_secret_key_name
  description = var.ssm_secret_key_description
  type        = "SecureString"
  value       = aws_iam_access_key.this.secret
  tier        = "Standard"
}
