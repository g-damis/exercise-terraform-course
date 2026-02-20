variable "name_prefix" {
  description = "Prefisso per naming risorse"
  type        = string
}

variable "common_tags" {
  description = "Tag comuni da applicare"
  type        = map(string)
  default     = {}
}

variable "lambda_zip_path" {
  description = "Path locale allo zip della Lambda (es: ./build/image-processing.zip)"
  type        = string
}

variable "runtime" {
  description = "Runtime Lambda"
  type        = string
  default     = "nodejs20.x"
}

variable "handler" {
  description = "Handler Lambda"
  type        = string
  default     = "index.handler"
}

variable "architectures" {
  description = "Architettura Lambda: [\"x86_64\"] o [\"arm64\"]"
  type        = list(string)
  default     = ["x86_64"]

  validation {
    condition     = length(var.architectures) == 1 && contains(["x86_64", "arm64"], var.architectures[0])
    error_message = "architectures deve essere [\"x86_64\"] oppure [\"arm64\"]."
  }
}

variable "memory_mb" {
  description = "Memoria Lambda in MB"
  type        = number
  default     = 1500
}

variable "timeout_seconds" {
  description = "Timeout Lambda in secondi"
  type        = number
  default     = 60
}

variable "log_retention_days" {
  description = "Retention CloudWatch Logs in giorni"
  type        = number
  default     = 14
}

# --- Inputs ---
variable "source_bucket_name" {
  description = "Nome bucket S3 con immagini originali"
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN bucket S3 con immagini originali"
  type        = string
}

variable "store_transformed_images" {
  description = "Se true, abilita upload su bucket transformed"
  type        = bool
  default     = true
}

variable "transformed_bucket_name" {
  description = "Nome bucket S3 immagini trasformate (null/empty se store_transformed_images=false)"
  type        = string
  default     = null
}

variable "transformed_bucket_arn" {
  description = "ARN bucket S3 immagini trasformate (null se store_transformed_images=false)"
  type        = string
  default     = null
}

variable "transformed_image_cache_ttl" {
  description = "Valore Cache-Control da applicare agli oggetti trasformati (repo: transformedImageCacheTTL)"
  type        = string
  default     = "max-age=31622400"
}

variable "max_image_size_bytes" {
  description = "Max image size in bytes (repo: maxImageSize)"
  type        = number
  default     = 4700000
}

variable "invoke_mode" {
  description = "Invoke mode Function URL: BUFFERED o RESPONSE_STREAM"
  type        = string
  default     = "BUFFERED"

  validation {
    condition     = contains(["BUFFERED", "RESPONSE_STREAM"], var.invoke_mode)
    error_message = "invoke_mode deve essere BUFFERED oppure RESPONSE_STREAM."
  }
}
