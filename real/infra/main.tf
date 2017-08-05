
provider "aws" {
  access_key = "${ var.access_key }"
  secret_key = "${ var.secret_key }"
  region     = "${ var.geo }"
}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["379101102735"] # Debian
}

resource "aws_key_pair" "main" {
    key_name   = "${ var.vpc_name }-main"
    public_key = "${ var.public_key }"
}

resource "aws_security_group" "main" {
  name        = "${ var.vpc_name }-main"
  description = "Default rules for hosts in ${ var.vpc_name } VPC"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    security_groups = ["${ aws_security_group.gw.id }"]
  }

  ingress {
    from_port   = 5666
    to_port     = 5666
    protocol = "tcp"
    security_groups = ["${ aws_security_group.icinga.id }"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
      Name = "${ var.vpc_name }-main"
  }
}

