# this file contain all output 

output "Public_IP" {
  value       = aws_instance.terraform_instance.public_ip
  description = " Public IP of terraform_instance "
  sensitive   = false
}
