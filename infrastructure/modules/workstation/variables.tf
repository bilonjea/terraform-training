variable "aws_region" {
  description = "AWS region utilisée par le workstation"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "session_id" {
  description = "Identifiant de session"
  type        = string
  default     = "TFVPA1-2026-09"
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

variable "student_credentials" {
  description = "Credentials AWS des étudiants créés par le module IAM"

  type = map(object({
    username         = string
    console_password = string
    access_key       = string
    secret_key       = string
  }))

  sensitive = true
}

variable "git_repositories" {
  description = "Repositories Git à cloner dans le workspace des étudiants"
  type        = list(string)

  default = [
    "https://github.com/bilonjea/terraform-formation-template.git"
  ]
}

variable "aws_account_id" {
  description = "AWS Account ID de la formation"
  type        = string
}

variable "allowed_aws_regions" {
  description = "Régions AWS autorisées pour les étudiants"
  type        = list(string)

  default = [
    "eu-west-3",
    "eu-west-2",
    "eu-west-1",
    "eu-central-1"
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

variable "iam_instance_profile_name" {
  description = "Nom de l'instance profile IAM du workstation"
  type        = string
}

variable "student_secret_arns" {
  description = "ARN des secrets AWS Secrets Manager des étudiants"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID du VPC de formation"
  type        = string
}

variable "subnet_id" {
  description = "ID du subnet de formation"
  type        = string
}

variable "formateur_public_key" {
  description = "Clé publique SSH du formateur"
  type        = string
}

variable "vault_private_ip" {
  description = "Adresse IP privée du serveur Vault"
  type        = string
}
