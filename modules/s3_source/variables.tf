variable "name_prefix" {
  description = "Prefisso usato per nominare il bucket quando viene creato dal modulo."
  type        = string
}

variable "common_tags" {
  description = "Tag comuni da applicare alle risorse create dal modulo."
  type        = map(string)
  default     = {}
}

variable "created_bucket_name" {
  description = "Nome esplicito del bucket da creare. Se null, il modulo usa un bucket_prefix."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Se true, consente il destroy del bucket creato anche se contiene oggetti."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Abilita il versioning quando il bucket e gestito dal modulo."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN della chiave KMS per SSE-KMS. Se null, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}
