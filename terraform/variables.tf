variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "eloquent-ai-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "app_version" {
  description = "Application version"
  type        = string
  default     = "1.0.0"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alerts"
  type        = string
  default     = "your-email@example.com"
}

variable "high_cpu_threshold" {
  description = "CPU utilization threshold for alerts"
  type        = number
  default     = 80
}

variable "high_memory_threshold" {
  description = "Memory utilization threshold for alerts"
  type        = number
  default     = 80
}