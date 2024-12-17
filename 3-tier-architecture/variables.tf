variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "3-tier-architecture"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "azs" {
  type        = list(string)
  description = "The availability zones to create resources in"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnets to create"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnets" {
  type        = list(string)
  description = "The private subnets to host the application"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_subnets" {
  type        = list(string)
  description = "The private subnets to host the database"
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}
