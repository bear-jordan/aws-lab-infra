variable "default_tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "aws-lab"
  }
}

# Networking
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
