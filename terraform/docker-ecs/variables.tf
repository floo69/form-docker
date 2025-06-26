variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "ecr_backend_image_url" {
  description = "Full ECR image URL for the Flask backend"
  type        = string
}

variable "ecr_frontend_image_url" {
  description = "Full ECR image URL for the Express frontend"
  type        = string
}

variable "mongodb_uri" {
  description = "MongoDB connection URI"
  type        = string
  sensitive   = true
}
