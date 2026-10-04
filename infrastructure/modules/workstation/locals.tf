locals {
  students = [
    for i in range(var.student_count) :
    format("student%02d", i + 1)
  ]

  student_credentials = {
    for student, credentials in var.student_credentials :
    student => merge(
      credentials,
      {
        console_password_b64 = base64encode(
          credentials.console_password
        )
      }
    )
  }

  student_password_b64 = base64encode(
    random_password.student.result
  )

  name_prefix = "terraform-training"

}