variable "name_prefix" {
  type        = string
  description = "Prefisso per naming risorse"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Tag comuni"
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "store_transformed_images" {
  type    = bool
  default = true
}

variable "transformed_bucket_name" {
  type    = string
  default = null
}

variable "transformed_bucket_arn" {
  type    = string
  default = null
}

variable "transformed_bucket_regional_domain_name" {
  type    = string
  default = null
}

variable "lambda_function_url" {
  type        = string
  description = "Lambda Function URL (origin secondario)"
}

variable "lambda_function_name" {
  type        = string
  description = "Nome Lambda (serve per aws_lambda_permission su Function URL)"
}

variable "enable_origin_shield" {
  type    = bool
  default = true
}

variable "origin_shield_region" {
  type    = string
  default = null
}

variable "failover_status_codes" {
  type    = list(number)
  default = [403]
}
