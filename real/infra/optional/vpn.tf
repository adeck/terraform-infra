
module "vpn" {
    name= "vpn"
    source = "./service"
    service_dns = "niflheim"

    instance_ami = "${ var.instance_ami }"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.vpn.id }"
    ]
    subnet_id = "${ aws_subnet.infra.id }"
    domain = "${ var.domain }"
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

  tags {
      Name = "${ var.vpc_name }-vpn"
  }
}


