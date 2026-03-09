output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "s3_bucket_name" {
  description = "Name of the encrypted S3 bucket"
  value       = aws_s3_bucket.secure_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the encrypted S3 bucket"
  value       = aws_s3_bucket.secure_bucket.arn
}

output "security_audit_role_arn" {
  description = "ARN of the security audit IAM role"
  value       = aws_iam_role.security_audit.arn
}
