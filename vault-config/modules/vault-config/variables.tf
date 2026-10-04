variable "vault_address" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "workstation_role_name" {
  type = string
}

variable "mount" {
  description = "Mount KV v2 de Vault"
  type        = string
}
