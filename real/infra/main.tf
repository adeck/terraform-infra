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

# TODO -- note that this uses "stretch" despite the current stable being "buster".
#           "buster" is not yet available as an AMI from the main debian account.
data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["379101102735"] # Debian
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


