
terraform {
  cloud {
    organization = "mohamedanwer006"

    workspaces {
      name = "test-workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

  }
}


locals {
  created_by = "mo_admin"
  name       = "terraform_instance"
}

# resources

# create instannce in AZ -1
resource "aws_instance" "terraform_instance" {
  instance_type = var.instance_type
  ami           = "ami-0ed9277fb7eb570c9"
  tags = {
    Name       = local.name
    Created_by = local.created_by
  }
}

# // create instance in AZ-2
# resource "aws_instance" "MyEC2_2" {
#   instance_type = var.instanceType
#   ami           = "ami-002068ed284fb165b"
#   provider      = aws.aws2
#   tags = {
#     Name      = "${local.name} 2 "
#     CreatedBy = local.createdBy
#   }
# }
