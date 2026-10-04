resource "vault_mount" "training" {
  path = var.mount
  type = "kv"

  options = {
    version = "2"
  }

  description = "Secrets de la formation Terraform"
}