output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.mi_vpc.id
}

output "subnet_id" {
  description = "ID de la Subred Pública"
  value       = aws_subnet.mi_subred_publica.id
}
