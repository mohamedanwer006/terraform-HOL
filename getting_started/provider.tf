


# AWS provide
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "mohamedanwer006_admin"
  region                  = "us-east-1"
}

provider "aws" {
  profile = "mohamedanwer006_admin"
  region  = "us-east-2"
  alias   = "aws-us-east-2"
}
