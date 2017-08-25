
resource "aws_key_pair" "main" {
    key_name   = "{{ vpc.name }}-main"
    public_key = "{{ ssh.public_key }}"
}

resource "aws_security_group" "main" {
  name        = "{{ vpc.name }}-main"
  description = "Default rules for hosts in {{ vpc.name }} VPC"
  vpc_id = "${ aws_vpc.main.id }"

  tags {
      Name = "{{ vpc.name }}-main"
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

