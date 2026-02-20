aws_region   = "eu-south-1"
aws_profile  = "corso-terraform"
project_name = "terraform-exercise"
environment  = "dev"

# crea bucket source automaticamente:
source_created_bucket_name = "source-bucket-tf-course"

source_force_destroy     = true
source_enable_versioning = false
source_kms_key_arn       = null

transformed_enabled                         = true
transformed_created_bucket_name             = "transformed-bucket-tf-course"
transformed_expiration_days                 = 90
transformed_abort_incomplete_multipart_days = 7
transformed_force_destroy                   = true
transformed_enable_versioning               = false
transformed_kms_key_arn                     = null

lambda_zip_path = "./build/image-processing.zip"
