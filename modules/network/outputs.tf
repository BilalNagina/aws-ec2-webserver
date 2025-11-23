output "vpc_id_value" {
  value = aws_vpc.this.id
}

output "subnet_id_value" {
  value = aws_subnet.public.id
}