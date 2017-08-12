
#### monitoring SG

resource "aws_security_group" "monitoring" {
  name        = "${ var.vpc_name }-monitoring"
  description = "monitoring master servers"
  vpc_id = "${ var.vpc_id }"
  tags {
      Name = "${ var.vpc_name }-monitoring"
  }
}

resource "aws_security_group_rule" "inbound_allow_grafana" {
  type        = "ingress"
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  source_security_group_id = "${ var.ingress_sg_id }"
  security_group_id = "${ aws_security_group.monitoring.id }"
}

#### default SG

# for icinga w/ nrpe
resource "aws_security_group_rule" "inbound_allow_nrpe" {
  type            = "ingress"
  from_port       = 5666
  to_port         = 5666
  protocol        = "tcp"
  source_security_group_id = "${ aws_security_group.monitoring.id }"
  security_group_id = "${ var.default_sg_id }"
}

