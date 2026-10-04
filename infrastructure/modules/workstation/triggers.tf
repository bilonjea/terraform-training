resource "terraform_data" "workstation_config" {
  input = {
    credentials_mode = var.credentials_mode
    session_id       = var.session_id
  }
}