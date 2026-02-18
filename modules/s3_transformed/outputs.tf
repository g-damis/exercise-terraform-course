output "bucket_name" {
  value       = var.enabled ? aws_s3_bucket.transformed_bucket[0].id : null
  description = "Nome del bucket transformed in uso."
}

output "bucket_arn" {
  value       = var.enabled ? aws_s3_bucket.transformed_bucket[0].arn : null
  description = "ARN del bucket transformed in uso."
}
