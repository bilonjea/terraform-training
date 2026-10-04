module "vault_config" {
  source = "./modules/vault-config"

  vault_address = var.vault_address
  mount         = var.vault_mount

  aws_account_id = var.aws_account_id

  workstation_role_name = "terraform-training-workstation-role"
}


module "vault_secrets" {
  source = "./modules/vault-secrets"

  mount = var.vault_mount

  student_count       = var.student_count
  student_credentials = data.terraform_remote_state.infrastructure.outputs.student_aws_credentials

  depends_on = [
    module.vault_config
  ]
}
