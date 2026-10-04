output "student_secret_arns" {
  description = "ARN des secrets Secrets Manager des étudiants"

  value = [
    for student in local.students :
    aws_secretsmanager_secret.student[student].arn
  ]
}