output "instance_id" {
  value = aws_instance.name.id
}

output "instance_public_ip" {
  value = aws_instance.name.public_ip
}
