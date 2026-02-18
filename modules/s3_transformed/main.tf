resource "aws_s3_bucket" "transformed_bucket" {
  count         = var.enabled ? 1 : 0
  bucket        = var.created_bucket_name != null && trimspace(var.created_bucket_name) != "" ? trimspace(var.created_bucket_name) : null
  bucket_prefix = var.created_bucket_name == null || trimspace(var.created_bucket_name) == "" ? "${var.name_prefix}-transformed-" : null
  force_destroy = var.force_destroy
  tags          = var.common_tags
}

locals {
  kms_key_arn = var.kms_key_arn == null ? null : trimspace(var.kms_key_arn)
}

resource "aws_s3_bucket_ownership_controls" "transformed_bucket_ownership_controls" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.transformed_bucket[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "transformed_bucket_public_access_block" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.transformed_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "transformed_bucket_encryption" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.transformed_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = local.kms_key_arn != null && local.kms_key_arn != "" ? "aws:kms" : "AES256"
      kms_master_key_id = local.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "transformed_bucket_versioning" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.transformed_bucket[0].id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "transformed_bucket_lifecycle" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.transformed_bucket[0].id

  rule {
    id     = "expire-transformed-images"
    status = "Enabled"

    expiration {
      days = var.expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_multipart_days
    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.enable_versioning ? [1] : []
      content {
        noncurrent_days = var.expiration_days
      }
    }
  }
}
