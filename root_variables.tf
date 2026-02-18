variable "aws_region" {
  description = "AWS region dove deployare lo stack (Lambda regionale, S3, ecc.)"
  type        = string
}

variable "aws_profile" {
  description = "Profilo AWS CLI da usare (es. profilo Leapp)."
  type        = string
}

variable "project_name" {
  description = "Nome progetto (usato per naming/tag)"
  type        = string

  validation {
    condition     = length(var.project_name) >= 2 && length(var.project_name) <= 20
    error_message = "project_name deve essere tra 2 e 20 caratteri."
  }
}

# --- S3 source module inputs ---

variable "source_created_bucket_name" {
  description = "Override opzionale del nome bucket se il modulo deve crearlo (deve essere globalmente unico). Se null, viene generato automaticamente."
  type        = string
  default     = null
}

variable "source_force_destroy" {
  description = "Se true e il bucket source è creato dal modulo, consente destroy anche se non è vuoto (solo lab/dev)."
  type        = bool
  default     = false
}

variable "source_enable_versioning" {
  description = "Abilita versioning sul bucket source (se gestito dal modulo)."
  type        = bool
  default     = false
}

variable "source_kms_key_arn" {
  description = "Se valorizzata, abilita SSE-KMS sul bucket source. Se null, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}
