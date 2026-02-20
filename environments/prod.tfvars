aws_region   = "eu-south-1"
aws_profile  = "corso-terraform"
project_name = "terraform-exercise"
environment  = "prod"

source_created_bucket_name = null
source_force_destroy       = false
source_enable_versioning   = true
source_kms_key_arn         = null

store_transformed_images                    = true
transformed_enabled                         = true
transformed_created_bucket_name             = null
transformed_expiration_days                 = 90
transformed_abort_incomplete_multipart_days = 7
transformed_force_destroy                   = false
transformed_enable_versioning               = true
transformed_kms_key_arn                     = null

lambda_zip_path           = "./build/image-processing.zip"
lambda_memory_mb          = 1500
lambda_timeout_seconds    = 60
lambda_architecture       = "x86_64"
transformed_cache_control = "max-age=31622400"
max_image_size_bytes      = 4700000
