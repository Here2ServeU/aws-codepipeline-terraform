variable "AWS_REGION" {
  default = "us-east-1"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
  default     = ["100.0.101.0/24", "100.0.102.0/24", "100.0.103.0/24"]  # Hardcoded private subnets
}


variable "private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
  default     = ["100.0.104.0/24", "100.0.105.0/24", "100.0.106.0/24"]  # Hardcoded private subnets
}


variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]  # Hardcoded availability zones
}

