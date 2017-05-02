
resource "aws_route53_record" "vpn" {
  zone_id = "${ aws_route53_zone.infra.zone_id }"
  name    = "niflheim"
  type    = "A"
  ttl     = "300"
  records = ["${ aws_eip.vpn.public_ip }"]
}

resource "aws_eip" "vpn" {
    instance = "${ aws_instance.vpn.id }"
    vpc      = true
}

resource "aws_instance" "vpn" {
  ami           = "${ var.instance_ami }"
  instance_type = "t2.micro"
  key_name = "${ aws_key_pair.main.key_name }"
  vpc_security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.vpn.id }"
    ]
  subnet_id = "${ aws_subnet.infra.id }"
  tags {
    Name = "${ var.vpc_name }-vpn"
    Description = "Managed by terraform"
  }
}


resource "aws_security_group" "vpn" {
  name        = "${ var.vpc_name }-vpn"
  description = "Allow inbound VPN traffic on 443"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

