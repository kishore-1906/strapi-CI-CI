variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type        = string
  description = "AMI for EC2 instance"
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "dockerhub_username" {
  type        = string
  description = "kishore190"
}

variable "image_tag" {
  type        = string
  description = "CI/CD generated image tag"
}

