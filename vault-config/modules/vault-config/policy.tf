## vault policy write workstation-training ...
resource "vault_policy" "workstation_training" {
  name = "workstation-training"

  policy = <<-EOT
path "${var.mount}/data/students/*" {
  capabilities = ["read"]
}
EOT
}