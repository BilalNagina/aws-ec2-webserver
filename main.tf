terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  default_public_key = file("${path.module}/ssh/id_rsa.pub")

}

module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "ec2_instance" {
  source = "./modules/ec2"

  vpc_id    = module.network.vpc_id_value
  subnet_id = module.network.subnet_id_value

  instance_type = var.instance_type
  key_name      = var.key_name
  public_key    = local.default_public_key
  ssh_cidr      = var.ssh_cidr

  user_data = templatefile("${path.module}/userdata/install.sh", {
    DOCROOT = "/usr/share/nginx/html"
  })
}
