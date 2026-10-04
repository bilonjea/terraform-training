output "vpc_id" {
  description = "ID du VPC de formation"
  value       = aws_vpc.training.id
}

output "subnet_id" {
  description = "ID du subnet public de formation"
  value       = aws_subnet.public.id
}