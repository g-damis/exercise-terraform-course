output "bucket_name" {
  description = "Nome del bucket source in uso."
  value       = aws_s3_bucket.source_bucket.id
}

output "bucket_arn" {
  description = "ARN del bucket source in uso."
  value       = aws_s3_bucket.source_bucket.arn
}
