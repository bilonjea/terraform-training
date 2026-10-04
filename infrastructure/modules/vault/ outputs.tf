output "vault_private_ip" {
  description = "Private IP address of Vault"
  value       = aws_instance.vault.private_ip
}

output "vault_url" {
  description = "Vault URL accessible depuis le VPC"
  value       = "http://${aws_instance.vault.private_ip}:8200"
}

output "vault_public_ip" {
  description = "Public IP address of Vault EC2"
  value       = aws_eip.vault.public_ip
}