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

  formateur_public_key = file(
    pathexpand("~/.ssh/id_ed25519.pub")
  )

  workstation_az = sort(
    data.aws_ec2_instance_type_offerings.workstation.locations
  )[0]

  name_prefix = "terraform-training"
  
}