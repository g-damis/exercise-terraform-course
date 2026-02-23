# Bucket policy: allow CloudFront to read transformed objects
data "aws_iam_policy_document" "transformed_bucket_policy" {
  statement {
    sid       = "AllowCloudFrontReadTransformed"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${var.transformed_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "transformed" {
  count  = var.store_transformed_images ? 1 : 0
  bucket = var.transformed_bucket_name
  policy = data.aws_iam_policy_document.transformed_bucket_policy.json
}

# Allow CloudFront to invoke Lambda Function URL (AWS_IAM)
resource "aws_lambda_permission" "allow_cloudfront_invoke_function_url" {
  statement_id           = "AllowCloudFrontInvokeFunctionUrl"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = var.lambda_function_name
  principal              = "cloudfront.amazonaws.com"
  source_arn             = aws_cloudfront_distribution.this.arn
  function_url_auth_type = "AWS_IAM"
}
