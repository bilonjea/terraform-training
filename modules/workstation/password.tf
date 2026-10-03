resource "random_password" "student" {
  length           = 16
  special          = true
  override_special = "_%@#"
}