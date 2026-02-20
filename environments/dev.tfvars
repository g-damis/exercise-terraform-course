aws_region   = "eu-south-1"
aws_profile  = "corso-terraform"
project_name = "terraform-exercise"
environment  = "dev"

source_created_bucket_name = null
source_force_destroy       = true
source_enable_versioning   = false
source_kms_key_arn         = null

transformed_enabled                         = true
transformed_created_bucket_name             = null
transformed_expiration_days                 = 30
transformed_abort_incomplete_multipart_days = 3
transformed_force_destroy                   = true
transformed_enable_versioning               = false
transformed_kms_key_arn                     = null
