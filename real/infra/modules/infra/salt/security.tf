
#### salt SG

resource "aws_security_group" "salt" {
  name        = "${ var.vpc_name }-salt"
  description = "Allow inbound salt minion traffic to the master"
  vpc_id = "${ var.vpc_id }"

  ingress {
    from_port   = 4505
    to_port     = 4506
    protocol = "tcp"
    security_groups = ["${ var.default_sg_id }"]
  }

  tags {
      Name = "${ var.vpc_name }-salt"
  }
}

