
#### salt SG

resource "aws_security_group" "salt" {
  name        = "{{ vpc.name }}-salt"
  description = "Allow inbound salt minion traffic to the master"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 4505
    to_port     = 4506
    protocol = "tcp"
    security_groups = ["${ aws_security_group.main.id }"]
  }

  tags {
      Name = "{{ vpc.name }}-salt"
  }
}

