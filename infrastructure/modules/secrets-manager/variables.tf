variable "student_credentials" {
  description = "Credentials AWS des étudiants"
  type = map(object({
    username         = string
    console_password = string
    access_key       = string
    secret_key       = string
  }))
  sensitive = true
}

variable "name_prefix" {
  description = "Préfixe des secrets"
  type        = string
  default     = "terraform-training"
}


variable "student_count" {
  description = "Nombre d'étudiants"
  type        = number

  validation {
    condition     = var.student_count >= 1 && var.student_count <= 20
    error_message = "student_count doit être compris entre 1 et 20."
  }
}

variable "session_id" {
  description = "Identifiant de session"
  type        = string
  default     = "TFVPA1-2026-09"
}