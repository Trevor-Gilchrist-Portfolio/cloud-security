variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "security-portfolio"
}

variable "environment" {
  description = "Deployment environment identifier"
  type        = string
  default     = "lab"
}