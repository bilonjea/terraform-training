resource "aws_secretsmanager_secret" "student" {
  for_each = toset(local.students)

  name = "${var.name_prefix}/${var.session_id}/${each.key}"
}

resource "aws_secretsmanager_secret_version" "student" {
  for_each = toset(local.students)

  secret_id = aws_secretsmanager_secret.student[each.key].id

  secret_string = jsonencode({
    username         = var.student_credentials[each.key].username
    console_password = var.student_credentials[each.key].console_password
    access_key       = var.student_credentials[each.key].access_key
    secret_key       = var.student_credentials[each.key].secret_key
  })
}