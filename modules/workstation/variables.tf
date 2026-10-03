variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
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
  default     = "557170680994"
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
