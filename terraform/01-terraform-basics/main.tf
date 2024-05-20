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

# Plan - Execute
resource "aws_s3_bucket" "my-s3-bucket-321" {
    bucket = "my-s3-bucket-321-ch1m1k3-rangak-001"
    versioning {
        enabled = true
    }
}

# Create New IAM USER
resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user_ch1m1k3"
}

# STATE
# DESIRED - KNOWN - ACTUAL 

output "my-s3-bucket-321" {
    value = aws_s3_bucket.my-s3-bucket-321.versioning[0].enabled
}