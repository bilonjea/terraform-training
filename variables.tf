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

variable "aws_account_id" {
  description = "AWS Account ID de la formation"
  type        = string
  default     = "557170680994"
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

variable "git_repositories" {
  description = "Repositories Git à cloner dans le workspace des étudiants"
  type        = list(string)

  default = [
    "https://github.com/bilonjea/terraform-formation-template.git"
  ]
}

variable "session_id" {
  description = "Identifiant de session"
  type        = string
  default     = "TFVPA1-2026-09"
}

variable "create_workstation" {
  description = "Créer le workstation de secours"
  type        = bool
  default     = false
}


