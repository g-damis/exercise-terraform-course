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
