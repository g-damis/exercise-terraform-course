module "s3_source" {
  source = "./modules/s3_source"

  name_prefix = local.name_prefix
  common_tags = local.common_tags

  created_bucket_name = var.source_created_bucket_name

  force_destroy     = var.source_force_destroy
  enable_versioning = var.source_enable_versioning
  kms_key_arn       = var.source_kms_key_arn
}
