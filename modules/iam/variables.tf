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
