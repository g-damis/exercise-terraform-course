locals {
  function_name = "${var.name_prefix}-image-processing"

  tags = merge(var.common_tags, {
    Name = local.function_name
    Role = "image-processing"
  })

  # Repo behavior: se transformedImageBucketName è valorizzata, fa upload
  transformed_bucket_name_effective = var.store_transformed_images ? coalesce(var.transformed_bucket_name, "") : ""
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${local.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = local.tags
}

data "aws_iam_policy_document" "inline" {
  # CloudWatch Logs
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  # Read original images
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.source_bucket_arn}/*"]
  }

  # Write transformed images (solo se abilitato)
  dynamic "statement" {
    for_each = (var.store_transformed_images && var.transformed_bucket_arn != null && trimspace(var.transformed_bucket_arn) != "") ? [1] : []
    content {
      actions = [
        "s3:PutObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ]
      resources = ["${var.transformed_bucket_arn}/*"]
    }
  }

  dynamic "statement" {
    for_each = (var.store_transformed_images && var.transformed_bucket_arn != null && trimspace(var.transformed_bucket_arn) != "") ? [1] : []
    content {
      actions = [
        "s3:ListBucketMultipartUploads"
      ]
      resources = [var.transformed_bucket_arn]
    }
  }
}

resource "aws_iam_role_policy" "lambda_inline_policy" {
  name   = "${local.function_name}-inline"
  role   = aws_iam_role.lambda_execution_role.id
  policy = data.aws_iam_policy_document.inline.json
}

# Controllo retention logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_days
  tags              = local.tags
}

resource "aws_lambda_function" "image_processor" {
  function_name = local.function_name
  role          = aws_iam_role.lambda_execution_role.arn

  runtime       = var.runtime
  handler       = var.handler
  architectures = var.architectures

  memory_size = var.memory_mb
  timeout     = var.timeout_seconds

  filename = var.lambda_zip_path
  # Permette il plan anche quando lo zip non è ancora stato generato in locale.
  source_code_hash = try(filebase64sha256(var.lambda_zip_path), null)

  # Env vars IDENTICHE alla repo
  environment {
    variables = {
      originalImageBucketName    = var.source_bucket_name
      transformedImageBucketName = local.transformed_bucket_name_effective
      transformedImageCacheTTL   = var.transformed_image_cache_ttl
      maxImageSize               = tostring(var.max_image_size_bytes)
    }
  }

  tags = local.tags

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}

# Function URL (origin secondario in CloudFront failover)
resource "aws_lambda_function_url" "function_url" {
  function_name      = aws_lambda_function.image_processor.function_name
  authorization_type = "NONE" # Per debug iniziale poi aggiungo AWS_IAM così non la rendo pubblica
  invoke_mode        = var.invoke_mode
}
