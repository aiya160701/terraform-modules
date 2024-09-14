variable "instance_type" {
  type        = string
  description = "This is instance type"
  default     = "t2.micro"

}

variable "Linux2023_ami" {
  default = "ami-0182f373e66f89c85"
}

variable "team" {
  default = "devops"
}

variable "env" {
  default = "dev"
}

variable "project" {
  default = "superapp"
}

variable "application_tier" {
  default = "frontend"

}

variable "resource" {
  default = "ec2"
}

variable "ManagedBy" {
  default = "terraform"
}

variable "owner" {
  default = "Aiya"
}

variable "vpc_cidr" {
  # default = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  # default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "AZs" {
  # default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


variable "private_subnet_cidrs" {
  # default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}