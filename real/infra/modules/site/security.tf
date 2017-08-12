
resource "aws_key_pair" "main" {
    key_name   = "${ var.vpc_name }-main"
    public_key = "${ var.public_key }"
}

resource "aws_security_group" "main" {
  name        = "${ var.vpc_name }-main"
  description = "Default rules for hosts in ${ var.vpc_name } VPC"
  vpc_id = "${ aws_vpc.main.id }"

  tags {
      Name = "${ var.vpc_name }-main"
  }
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${ aws_security_group.main.id }"
}

