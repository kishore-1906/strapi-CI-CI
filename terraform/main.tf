terraform {
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

# Security Group for Strapi
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-01"
  description = "Allow Strapi and SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "Strapi UI"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance to run Strapi
resource "aws_instance" "strapi" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name               = var.key_name

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    dockerhub_username = var.dockerhub_username
    image_tag          = var.image_tag
  })

  tags = {
    Name = "Strapi-Server"
  }
}

