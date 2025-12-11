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

# -----------------------------------------
# 1️⃣ Detect existing SG safely (no crash)
# -----------------------------------------
data "aws_security_groups" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["strapi-sg-01"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
# Note: aws_security_groups (plural) NEVER crashes even if 0 found

# -----------------------------------------
# 2️⃣ Create SG only if it does NOT exist
# -----------------------------------------
resource "aws_security_group" "strapi_sg" {
  count = length(data.aws_security_groups.existing_sg.ids) == 0 ? 1 : 0

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

# -----------------------------------------
# 3️⃣ Select correct SG ID (existing OR new)
# -----------------------------------------
locals {
  strapi_sg_id = (
    length(data.aws_security_groups.existing_sg.ids) > 0 ?
    data.aws_security_groups.existing_sg.ids[0] :
    aws_security_group.strapi_sg[0].id
  )
}

# -----------------------------------------
# 4️⃣ EC2 Instance
# -----------------------------------------
resource "aws_instance" "strapi" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id

  # Uses existing or newly created SG
  vpc_security_group_ids = [local.strapi_sg_id]

  key_name = var.key_name

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    dockerhub_username = var.dockerhub_username
    image_tag          = var.image_tag
  })

  tags = {
    Name = "Strapi-Server"
  }
}

