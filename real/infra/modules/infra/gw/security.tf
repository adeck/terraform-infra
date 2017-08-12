
#### gw SG

resource "aws_security_group" "gw" {
  name        = "${ var.vpc_name }-gw"
  description = "Allow inbound SSH traffic from trusted networks"
  vpc_id = "${ var.vpc_id }"

  tags {
      Name = "${ var.vpc_name }-gw"
  }
}

resource "aws_security_group_rule" "inbound_allow_ssh_to_gw" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks = ["${ var.trusted_cidr }"]
  security_group_id = "${ aws_security_group.gw.id }"
}


#### default SG

resource "aws_security_group_rule" "inbound_allow_ssh_from_gw" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  source_security_group_id = "${ aws_security_group.gw.id }"
  security_group_id = "${ var.default_sg_id }"
}


