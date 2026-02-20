output "source_bucket_name" {
  value = module.s3_source.bucket_name
}

output "environment" {
  value = var.environment
}

output "source_bucket_arn" {
  value = module.s3_source.bucket_arn
}

output "transformed_bucket_name" {
  value = module.s3_transformed.bucket_name
}

output "transformed_bucket_arn" {
  value = module.s3_transformed.bucket_arn
}

