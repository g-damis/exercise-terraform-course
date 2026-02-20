output "function_name" {
  value = aws_lambda_function.image_processor.function_name
}

output "function_arn" {
  value = aws_lambda_function.image_processor.arn
}

output "role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "function_url" {
  value = aws_lambda_function_url.function_url.function_url
}

output "function_url_auth_type" {
  value = aws_lambda_function_url.function_url.authorization_type
}
