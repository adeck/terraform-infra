
provider "aws" {
  access_key = "${ var.access_key }"
  secret_key = "${ var.secret_key }"
  region     = "${ var.geo }"
}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-jessie-*"]
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

  # saltmaster uplink
  egress {
    from_port       = 4505
    to_port         = 4506
    protocol        = "tcp"
    security_groups = ["${ aws_security_group.salt.id }"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # ntp
  egress {
    from_port       = 123
    to_port         = 123
    protocol        = "udp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # not whitelisting DNS / 53 b/c that's done over the link-local IP, so shouldn't be affected by SG config
  # plus, it's amazon special sauce. I don't think it *can* be blocked

  tags {
      Name = "${ var.vpc_name }-main"
  }
}

