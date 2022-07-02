#
# TODO: update this to work for recent terraform
#

module "appliance_icinga" {
    name = "icinga"
    source = "./appliance"
    vpc_name = var.vpc_name
    key_name = aws_key_pair.ssh.key_name
    security_group_ids = [
        aws_security_group.main.id,
        aws_security_group.icinga.id
    ]
    instance_ami = data.aws_ami.main.id
    subnet_id = aws_subnet.infra.id
    private_zone_id = aws_route53_zone.private.id
    private_domain_name = aws_route53_zone.private.name
}

resource "aws_security_group" "icinga" {
  name        = "icinga-${ var.vpc_name }"
  description = "icinga master servers"
  vpc_id = aws_vpc.main.id

  tags {
      Name = "icinga-${ var.vpc_name }"
  }
}

resource "aws_security_group_rule" "allow_icinga_incoming" {
    type        = "ingress"
    from_port   = 5666
    to_port     = 5666
    protocol    = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
    security_group_id       = aws_security_group.main.id
    source_security_group_id = aws_security_group.icinga.id
}



