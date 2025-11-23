variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair to create/use"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed for SSH (restrict in production)"
}
