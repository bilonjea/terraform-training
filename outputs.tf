output "student_aws_credentials" {
  description = "Credentials AWS des étudiants"

  value     = module.iam.student_aws_credentials
  sensitive = true
}

output "workstation_public_ip" {
  value = var.create_workstation ? module.workstation[0].workstation_public_ip : null
}

output "workstation_student_password" {
  value     = var.create_workstation ? module.workstation[0].student_password : null
  sensitive = true
}