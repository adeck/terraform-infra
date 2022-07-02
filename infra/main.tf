#
# This contains:
# - base AMI
# - main security zone
# - main SSH keypair
#


provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.geo
}

# as per: https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye
data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-*"] # debian "bullseye"
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"] # Debian
}

resource "aws_key_pair" "ssh" {
    key_name   = "ssh-${ var.vpc_name }"
    public_key = var.public_key
}

resource "aws_security_group" "main" {
  name        = "main-${ var.vpc_name }"
  description = "Default rules for hosts in ${ var.vpc_name } VPC"
  vpc_id = aws_vpc.main.id

  tags = {
      Name = "main-${ var.vpc_name }"
  }
}

resource "aws_security_group_rule" "allow_all_outgoing" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "all"
    cidr_blocks     = ["0.0.0.0/0"]
    security_group_id = aws_security_group.main.id
}


