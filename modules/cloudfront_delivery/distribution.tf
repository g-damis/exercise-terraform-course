locals {
  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-cloudfront"
    Role = "cloudfront-delivery"
  })

  # Lambda Function URL domain senza https:// e senza trailing slash
  lambda_domain = trimsuffix(regexreplace(var.lambda_function_url, "^https://", ""), "/")

  s3_origin_id     = "s3-transformed"
  lambda_origin_id = "lambda-fallback"
  origin_group_id  = "origin-group-transformed"
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name                              = "${var.name_prefix}-oac-s3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# NOTA: la traccia parla di OAC anche per Lambda URL (SigV4).
# Se il provider dovesse rifiutare origin_type="lambda", dimmelo: si gestisce con workaround.
resource "aws_cloudfront_origin_access_control" "lambda" {
  name                              = "${var.name_prefix}-oac-lambda"
  origin_access_control_origin_type = "lambda"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled     = true
  comment     = "${var.name_prefix} image optimization"
  price_class = var.price_class

  # Origin Lambda URL (sempre presente)
  origin {
    domain_name              = local.lambda_domain
    origin_id                = local.lambda_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.lambda.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Origin S3 transformed (solo se store_transformed_images=true)
  dynamic "origin" {
    for_each = var.store_transformed_images ? [1] : []
    content {
      domain_name              = var.transformed_bucket_regional_domain_name
      origin_id                = local.s3_origin_id
      origin_access_control_id = aws_cloudfront_origin_access_control.s3.id

      s3_origin_config {
        origin_access_identity = ""
      }

      dynamic "origin_shield" {
        for_each = var.enable_origin_shield ? [1] : []
        content {
          enabled              = true
          origin_shield_region = var.origin_shield_region
        }
      }
    }
  }

  # Origin group: S3 -> failover su Lambda se 403
  dynamic "origin_group" {
    for_each = var.store_transformed_images ? [1] : []
    content {
      origin_id = local.origin_group_id

      failover_criteria {
        status_codes = var.failover_status_codes
      }

      member { origin_id = local.s3_origin_id }
      member { origin_id = local.lambda_origin_id }
    }
  }

  default_cache_behavior {
    target_origin_id       = var.store_transformed_images ? local.origin_group_id : local.lambda_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true

    cache_policy_id          = aws_cloudfront_cache_policy.this.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.this.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.url_rewrite.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = local.tags
}
