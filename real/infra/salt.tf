
module "appliance_salt" {
    name = "salt"
    source = "./appliance"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.salt.id }"
    ]
    instance_ami = "${ data.aws_ami.main.id }"
    subnet_id = "${ aws_subnet.infra.id }"
    private_zone_id = "${ aws_route53_zone.private.id }"
    private_domain_name = "${ aws_route53_zone.private.name }"
}

resource "aws_security_group" "salt" {
  name        = "${ var.vpc_name }-salt"
  description = "Allow inbound salt minion traffic to the master"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 4505
    to_port     = 4506
    protocol = "tcp"
    security_groups = ["${ aws_security_group.main.id }"]
  }

  tags {
      Name = "${ var.vpc_name }-salt"
  }
}

