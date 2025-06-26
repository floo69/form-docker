output "backend_ip" {
  description = "Flask backend public IP"
  value       = aws_instance.backend.public_ip
}

output "frontend_ip" {
  description = "Express frontend public IP"
  value       = aws_instance.frontend.public_ip
}
