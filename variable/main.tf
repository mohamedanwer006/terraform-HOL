terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

variable "instance_type" {
  type        = string
  description = "the size of the instance to create"
  default     = "t2.micro"
  # validate instance type is free tier eligible t2.micro
  validation {
    condition     = can(regex("t2.micro", var.instance_type))
    error_message = "The instance type must be t2.mico ."
  }
}
variable "instance_ami" {
  type        = string
  description = "the ami of the instance to create"

  # validate instance ami
  validation {
    condition     = can(regex("^ami-", var.instance_ami))
    error_message = "The instance_ami is not avalid ami."
  }
}



provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "mohamedanwer006_admin"
}

resource "aws_instance" "web_instance" {
  instance_type = var.instance_type
  ami           = var.instance_ami
  tags = {
    Name = "web_instance"
  }
}


output "server" {
  value = {
    Public-IP = aws_instance.web_instance.public_ip,
    Host      = "http://${aws_instance.web_instance.public_dns} "
  }
}

