variable "region" {
    type        = string
    default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.10.0/24"
}

variable "subnet_cidr_a" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.10.0/27"
}

variable "subnet_cidr_b" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.10.32/27"
}

variable "subnet_cidr_c" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.10.10.64/27"
}

variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "Development"
}
