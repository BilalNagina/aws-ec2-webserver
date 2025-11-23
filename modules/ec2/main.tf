data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "this" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_instance" "name" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  user_data                   = var.user_data
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.id
  associate_public_ip_address = true
  tags = {
    Name = "web-server"
  }
}
