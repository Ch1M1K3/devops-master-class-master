variable "users" {
  default = {
    Ada : { country : "Netherlands", department : "EUR" },
    Obi : { country : "US", department : "NAM" },
    Kelechi : { country : "India", department : "ASIA" },
    Micheal : { country : "Nigeria", department : "AFR" }
  }
}

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

resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    #country: each.value
    country : each.value.country
    department : each.value.department
  }
}