output "student_aws_credentials" {
  description = "Credentials AWS des étudiants"
  value = {
    for student_id, user in aws_iam_user.students :
    student_id => {
      username         = user.name
      console_password = aws_iam_user_login_profile.students[student_id].password
      access_key       = aws_iam_access_key.students[student_id].id
      secret_key       = aws_iam_access_key.students[student_id].secret
    }
  }

  sensitive = true
}