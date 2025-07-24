variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "sap-infra-test"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "sap_infra_test"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "postgres"
}

variable "app_image_tag" {
  description = "Docker image tag for the application"
  type        = string
  default     = "latest"
}

variable "app_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "app_cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 512
}

variable "app_memory" {
  description = "Memory for ECS task (MiB)"
  type        = number
  default     = 1024
}

variable "app_min_count" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 2
}

variable "app_max_count" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 4
}

variable "cpu_target_value" {
  description = "Target value for CPU utilization"
  default     = 50
}

variable "memory_target_value" {
  description = "The target memory utilization percentage for scaling"
  type        = number
  default     = 50
}
