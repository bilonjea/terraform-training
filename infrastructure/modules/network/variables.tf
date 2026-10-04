variable "aws_region" {
  description = "AWS region utilisée par le workstation"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "availability_zone" {
  description = "Availability Zone utilisée par les instances de formation"
  type        = string
}