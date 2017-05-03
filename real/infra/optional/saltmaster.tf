
resource "aws_instance" "salt" {
    ami = "${ data.aws_ami.main.id }"
    instance_type = "t2.micro"
    key_name = "${ aws_key_pair.main.key_name }"
    vpc_security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.salt.id }",
    ]
    subnet_id = "${ aws_subnet.infra.id }"
    tags {
        Name = "${ var.vpc_name }-salt"
        Description = "Managed by terraform"
    }
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

