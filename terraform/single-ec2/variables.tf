variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "first-floyd"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu 24.04 AMI ID for your region"
  type        = string
  default     = "ami-0f918f7e67a3323f0"
}
