output "instance_public_ip" {
  value = module.ec2_instance.instance_public_ip
  description = "Public IP of the single EC2 instance (if provisioned)"
}