resource "aws_s3_bucket" "source_bucket" {
  bucket        = var.created_bucket_name != null && trimspace(var.created_bucket_name) != "" ? trimspace(var.created_bucket_name) : null
  bucket_prefix = var.created_bucket_name == null || trimspace(var.created_bucket_name) == "" ? "${var.name_prefix}-source-" : null
  force_destroy = var.force_destroy
  tags          = var.common_tags
}

locals {
  kms_key_arn = var.kms_key_arn == null ? null : trimspace(var.kms_key_arn)
}

resource "aws_s3_bucket_public_access_block" "source_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.source_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "source_bucket_ownership_controls" {
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source_bucket_encryption" {
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = local.kms_key_arn
      sse_algorithm     = local.kms_key_arn != null && local.kms_key_arn != "" ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}
