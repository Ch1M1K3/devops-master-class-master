terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create New IAM USER
resource "aws_iam_user" "my_iam_users" {
  count = 3
  name  = "my_iam_user_ch1m1k3_${count.index}"
}
