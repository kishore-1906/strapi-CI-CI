variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type        = string
  description = "AMI for EC2 instance"
  default     = ""   # safe for destroy
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "key_name" {
  type    = string
  default = ""
}

variable "dockerhub_username" {
  type        = string
  description = "DockerHub username"
  default     = "kishore190"
}

variable "image_tag" {
  type        = string
  description = "CI/CD generated image tag"
  default     = "latest"
}

