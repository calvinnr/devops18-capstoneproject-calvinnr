terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-southeast-1"
}

resource "aws_instance" "contoh" {
  ami           = "ami-002843b0a9e09324a"
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-as1-1a-d-contoh"
  }
}
