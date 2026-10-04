## vault auth enable aws
resource "vault_auth_backend" "aws" {
  type = "aws"
}


resource "vault_aws_auth_backend_role" "workstation" {
  backend = vault_auth_backend.aws.path
  role    = "workstation"

  auth_type = "iam"

  bound_iam_principal_arns = [
    "arn:aws:iam::${var.aws_account_id}:role/${var.workstation_role_name}"
  ]

  token_policies = [
    vault_policy.workstation_training.name
  ]

  token_ttl = 3600
}