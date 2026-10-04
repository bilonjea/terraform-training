output "instance_id" {
  value = aws_instance.workstation.id
}

output "public_ip" {
  value = aws_instance.workstation.public_ip
}

output "public_dns" {
  value = aws_instance.workstation.public_dns
}

output "workstation_public_ip" {
  description = "Elastic IP of the training workstation"
  value       = aws_eip.workstation.public_ip
}

output "student_password" {
  description = "Shared password for all student accounts and code-server"
  value       = random_password.student.result
  sensitive   = true
}
