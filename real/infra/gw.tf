
resource "aws_route53_record" "gw" {
  zone_id = "${ aws_route53_zone.infra.zone_id }"
  name    = "midgard"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_eip.gw.public_ip }"]
}

resource "aws_eip" "gw" {
    instance = "${ aws_instance.gw.id }"
    vpc      = true
}

resource "aws_instance" "gw" {
  ami           = "${ var.instance_ami }"
  instance_type = "t2.micro"
  key_name = "${ aws_key_pair.main.key_name }"
  vpc_security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.gw.id }"
    ]
  subnet_id = "${ aws_subnet.infra.id }"
  tags {
    Name = "${ var.vpc_name }-gw"
    Description = "Managed by terraform"
  }
}


resource "aws_security_group" "gw" {
  name        = "${ var.vpc_name }-gw"
  description = "Allow inbound SSH traffic from trusted networks"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    cidr_blocks = ["${ var.trusted_cidr }"]
  }
}

