variable "name_prefix" {
  description = "Prefisso usato per nominare il bucket quando viene creato dal modulo."
  type        = string
}

variable "common_tags" {
  description = "Tag comuni da applicare alle risorse create dal modulo."
  type        = map(string)
  default     = {}
}

variable "enabled" {
  description = "Se false, il bucket transformed non viene creato."
  type        = bool
  default     = true
}

variable "created_bucket_name" {
  description = "Nome esplicito del bucket transformed da creare. Se null, il modulo usa un bucket_prefix."
  type        = string
  default     = null
}

variable "expiration_days" {
  description = "Dopo quanti giorni eliminare le immagini trasformate (lifecycle)."
  type        = number
  default     = 90

  validation {
    condition     = var.expiration_days >= 1 && var.expiration_days <= 3650
    error_message = "expiration_days deve essere tra 1 e 3650."
  }
}

variable "abort_incomplete_multipart_days" {
  description = "Dopo quanti giorni abortire upload multipart incompleti."
  type        = number
  default     = 7

  validation {
    condition     = var.abort_incomplete_multipart_days >= 1 && var.abort_incomplete_multipart_days <= 30
    error_message = "abort_incomplete_multipart_days deve essere tra 1 e 30."
  }
}

variable "force_destroy" {
  description = "Se true, permette destroy anche se il bucket non è vuoto."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Abilita versioning sul bucket transformed."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "Se valorizzata, usa SSE-KMS con questa key. Se null, usa SSE-S3 (AES256)."
  type        = string
  default     = null
}
