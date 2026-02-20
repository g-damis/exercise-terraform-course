output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_arn" {
  value = aws_lambda_function.this.arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}

output "function_url" {
  value = aws_lambda_function_url.function_url.function_url
}

output "function_url_auth_type" {
  value = aws_lambda_function_url.function_url.authorization_type
}
