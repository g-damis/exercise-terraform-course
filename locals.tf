locals {
  # niente env: un prefisso semplice
  name_prefix = var.project_name

  common_tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}
