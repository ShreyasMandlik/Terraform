terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.5.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}
data "aws_vpc" "default_vpc_data" {
  default = true
}

data "aws_subnet" "default_subnet" {
  id     = "subnet-034e185bc2d4644cb"
  vpc_id = data.aws_vpc.default_vpc_data.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "shubham"
}

resource "aws_db_instance" "app_db" {
  identifier          = "app-db"
  db_name             = "pokemon"
  engine              = "mariadb"
  engine_version      = "10.6.11"
  instance_class      = "db.t2.micro"
  username            = "example_user"
  password            = "example_user"
  skip_final_snapshot = true
  allocated_storage   = 20
  availability_zone   = "ap-south-1a"
  port                = 3306

}