
resource "aws_instance" "adeck_testing" {
  ami           = "${ var.instance_ami }"
  associate_public_ip_address = "true"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${ aws_security_group.adeck_allow.id }"]
  subnet_id = "${ aws_subnet.main.id }"
  tags {
    Name = "adeck terraform test instance"
  }
}

resource "aws_security_group" "adeck_allow" {
  name        = "adeck_allow"
  description = "Allow all inbound traffic from trusted network"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol = "tcp"
    cidr_blocks = ["${ var.trusted_cidr }"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

