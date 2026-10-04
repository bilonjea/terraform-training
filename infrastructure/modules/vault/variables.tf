variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "ID du VPC de formation"
  type        = string
}

variable "subnet_id" {
  description = "Subnet du Vault"
  type        = string
}

variable "student_count" {
  description = "Nombre d'étudiants"
  type        = number

  validation {
    condition     = var.student_count >= 1 && var.student_count <= 20
    error_message = "student_count doit être compris entre 1 et 20."
  }
}

variable "formateur_public_key" {
  description = "Clé publique SSH du formateur"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Instance profile IAM du serveur Vault"
  type        = string
}

variable "vault_token" {
  description = "Root token Vault utilisé uniquement pour le POC"
  type        = string
  sensitive   = true
}
