variable "student_count" {
  description = "Nombre d'étudiants"
  type        = number

  validation {
    condition     = var.student_count >= 1 && var.student_count <= 20
    error_message = "student_count doit être compris entre 1 et 20."
  }
}

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

variable "mount" {
  description = "Mount KV v2 de Vault"
  type        = string
}