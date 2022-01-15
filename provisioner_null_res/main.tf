terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
}


# provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "mohamedanwer006_admin"
}

#ssh key pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6IQaP1HE9VKQOzJEZJLdnewEOcifghjq+FNJlDOhIS8UuTGug45ug69WQ2IVAg9VVwurTN2lkagGdpQgA6xWNHkQ7CvEzcsDZSNXDvmU65Q37bOhL9fCn2MOKj74CwqLRcSJEspypiVAjtwLop/i42rz/mB5psL7sWdKhDgSVaHpffnhoy8L41PW5vFyUwlFB81fWC/HdIrWmEMDDPx5f8bHASrqK2vwfRgv6ptR9JtYPUMIP9vE9zO55Kr7i7FSRWktS+w1pHFkY0FHaIKHNpF/1e59ITGEBudWMFbozdXO/sMSio+uTIVx5HkVQSTW6LCrylJfQuYWwC4/SSJr/WaXCmWzFcJDbZQTWbCQGPa6rDUCrB2K9HwiCKmOnIsT/uzxnjioWbdfRb+0BBrPLZl9Rp9pgbxl4ASpEj6pq34ri3SnNsS6OetagHpRgYNzD/U3OoyW7CQllVgzG02ctnNrZcKh7e/6vKmtgZC9NZl8feACNNh3eRtqCJpkT7sk= root@Inspiron-5559"
}

# Resoources
resource "aws_instance" "web_instance" {
  ami           = "ami-0ed9277fb7eb570c9"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name
  tags = {
    Name = "The_server"
  }
}

resource "null_resource" "resource_null" {
  depends_on = [
    aws_instance.web_instance
  ]
  triggers = {
    aws_instance.web_instance = [
      {
        events = [
          "reboot",
        ]
      }
    ]
  }
  provisioner "local-exec" {
  command = "echo 'hello world ${aws_instance.web_instanec.id}'"
  }
}

# output
output "host" {
  value = "http://${aws_instance.The_server.public_dns}"
}


