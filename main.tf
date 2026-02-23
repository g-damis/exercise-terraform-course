module "s3_source" {
  source = "./modules/s3_source"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  created_bucket_name = var.source_created_bucket_name

  force_destroy     = var.source_force_destroy
  enable_versioning = var.source_enable_versioning
  kms_key_arn       = var.source_kms_key_arn
}

module "s3_transformed" {
  source = "./modules/s3_transformed"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  enabled                         = var.transformed_enabled
  created_bucket_name             = var.transformed_created_bucket_name
  expiration_days                 = var.transformed_expiration_days
  abort_incomplete_multipart_days = var.transformed_abort_incomplete_multipart_days
  force_destroy                   = var.transformed_force_destroy
  enable_versioning               = var.transformed_enable_versioning
  kms_key_arn                     = var.transformed_kms_key_arn
}

module "lambda_transformer" {
  source = "./modules/lambda_transformer"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  lambda_zip_path = var.lambda_zip_path

  memory_mb       = var.lambda_memory_mb
  timeout_seconds = var.lambda_timeout_seconds
  architectures   = [var.lambda_architecture]

  source_bucket_name = module.s3_source.bucket_name
  source_bucket_arn  = module.s3_source.bucket_arn

  store_transformed_images    = var.store_transformed_images
  transformed_bucket_name     = module.s3_transformed.bucket_name
  transformed_bucket_arn      = module.s3_transformed.bucket_arn
  transformed_image_cache_ttl = var.transformed_cache_control
  max_image_size_bytes        = var.max_image_size_bytes
}

module "cloudfront_delivery" {
  source = "./modules/cloudfront_delivery"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  price_class = var.price_class

  store_transformed_images                = var.store_transformed_images
  transformed_bucket_name                 = module.s3_transformed.bucket_name
  transformed_bucket_arn                  = module.s3_transformed.bucket_arn
  transformed_bucket_regional_domain_name = module.s3_transformed.bucket_regional_domain_name

  lambda_function_url  = module.lambda_transformer.function_url
  lambda_function_name = module.lambda_transformer.function_name

  enable_origin_shield = var.enable_origin_shield
  origin_shield_region = var.origin_shield_region

  failover_status_codes = [403]
}
