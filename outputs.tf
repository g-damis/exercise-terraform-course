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

output "lambda_transformer_function_name" {
  value = module.lambda_transformer.function_name
}

output "lambda_transformer_function_arn" {
  value = module.lambda_transformer.function_arn
}

output "lambda_transformer_function_url" {
  value = module.lambda_transformer.function_url
}

output "cloudfront_domain_name" {
  value = module.cloudfront_delivery.domain_name
}
