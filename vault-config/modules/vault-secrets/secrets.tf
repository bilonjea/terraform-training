resource "vault_kv_secret_v2" "student" {
  for_each = toset(local.students)

  mount = var.mount
  name  = "students/${each.key}"

  data_json = jsonencode({
    username         = var.student_credentials[each.key].username
    console_password = var.student_credentials[each.key].console_password
    access_key       = var.student_credentials[each.key].access_key
    secret_key       = var.student_credentials[each.key].secret_key
  })
}