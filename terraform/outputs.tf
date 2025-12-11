output "strapi_instance_ip" {
  value       = aws_instance.strapi.public_ip
  description = "Public IP of Strapi EC2 instance"
}

output "strapi_url" {
  value       = "http://${aws_instance.strapi.public_ip}:1337"
  description = "Strapi URL"
}

