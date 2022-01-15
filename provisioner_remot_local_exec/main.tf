terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
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

# security group
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow http inbound traffic"
  vpc_id      = data.aws_vpc.main.id
  ingress = [

    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "public_sg"
  }
}


#  Vpc  defult id

data "aws_vpc" "main" {
  id = "vpc-02d6d72b04e36e419"
}


# Resoources
resource "aws_instance" "The_server" {
  ami                    = "ami-0ed9277fb7eb570c9"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"

  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/mohamed/.ssh/terraform")
      host        = self.public_ip
      port        = 22
      timeout     = "10m"
    }
    inline = [
      "echo ${self.private_ip} >> private_ips.txt",
      "ls -l / >> output.txt"
    ]
  }
  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/mohamed/.ssh/terraform")
      host        = self.public_ip
      port        = 22
      timeout     = "10m"
    }
    source      = "./README.md"
    destination = "/home/ec2-user/README.md"
  }


  tags = {
    Name = "Provisioner_test"
  }
}

# output
output "connect" {
  value = "ssh ec2-user@${aws_instance.The_server.public_dns} -i /root/.ssh/terraform"
}


