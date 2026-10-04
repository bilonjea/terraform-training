variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "student_count" {
  description = "Number of students using the rescue workstation"
  type        = number
  default     = 2

  validation {
    condition     = var.student_count >= 1 && var.student_count <= 20
    error_message = "student_count must be between 1 and 20."
  }
}

variable "vault_address" {
  description = "Adresse du serveur Vault"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID de la formation"
  type        = string
}

variable "vault_mount" {
  description = "Mount KV v2 de Vault"
  type        = string
  default     = "training"
}


