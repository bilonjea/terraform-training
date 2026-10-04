output "student_secret_paths" {
  description = "Chemins des secrets étudiants dans Vault"

  value = [
    for student in local.students :
    "${var.mount}/students/${student}"
  ]
}