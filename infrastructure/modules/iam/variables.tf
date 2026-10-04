variable "student_count" {
  description = "Nombre de comptes étudiants"
  type        = number
  default     = 2

  validation {
    condition     = var.student_count >= 1 && var.student_count <= 20
    error_message = "student_count doit être compris entre 1 et 20."
  }
}

variable "allowed_aws_regions" {
  description = "Régions AWS autorisées pour la formation"
  type        = list(string)

  default = [
    "eu-west-3",
    "eu-west-1",
    "eu-central-1",
    "us-east-1"
  ]
}

variable "credentials_mode" {
  description = "Mode de distribution des credentials"
  type        = string

  default = "local"

  validation {
    condition = contains([
      "local",
      "secrets_manager",
      "vault"
    ], var.credentials_mode)

    error_message = "credentials_mode doit être local, secrets_manager ou vault."
  }
}

variable "name_prefix" {
  description = "Préfixe des secrets"
  type        = string
  default     = "terraform-training"
}

variable "student_secret_arns" {
  description = "ARN des secrets Secrets Manager accessibles par le workstation"
  type        = list(string)
  default     = []
}

variable "create_workstation_secrets_policy" {
  description = "Créer la policy permettant au workstation de lire les secrets étudiants"
  type        = bool
  default     = false
}