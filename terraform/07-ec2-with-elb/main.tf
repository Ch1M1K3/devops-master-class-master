variable "aws_key_pair" {
  default = "~/aws/aws_keys/ch1m1k3-prac-kp.pem"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_default_vpc" "default" {
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  #vpc_id = "vpc-0b7860f5f2ab4d82f"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

#resource "aws_elb" "elb" {
#name            = "elb"
#subnets         = data.aws_subnets.default_subnets.ids
#security_groups = [aws_security_group.elb_sg.id]
#instances       = values(aws_instance.http_servers).*.id

#  listener {
#   instance_port     = 80
#  instance_protocol = "http"
# lb_port           = 80
#lb_protocol       = "http"
#}
#}

resource "aws_instance" "http_server" {
  #  ami = "ami-0a699202e5027c10d"
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "ch1m1k3-prac-kp"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  #subnet_id = "subnet-0922c66f3dcce2c1a"
  for_each  = data.aws_subnets.default_subnets.ids
  subnet_id = each.value

  tags = {
    name : "http_servers_${each.value}"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Welcome to De Adviser World!!! - Virtual Server is at ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}
