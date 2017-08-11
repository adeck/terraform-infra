
module "appliance_monitoring" {
    name = "monitoring"
    source = "./appliance"
    vpc_name = "${ var.vpc_name }"
    key_name = "${ aws_key_pair.main.key_name }"
    security_group_ids = [
        "${ aws_security_group.main.id }",
        "${ aws_security_group.monitoring.id }"
    ]
    instance_ami = "${ data.aws_ami.main.id }"
    subnet_id = "${ aws_subnet.infra.id }"
    private_zone_id = "${ aws_route53_zone.private.id }"
    private_domain_name = "${ aws_route53_zone.private.name }"
}

resource "aws_security_group" "monitoring" {
  name        = "${ var.vpc_name }-monitoring"
  description = "monitoring master servers"
  vpc_id = "${ aws_vpc.main.id }"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol = "tcp"
    security_groups = ["${ aws_security_group.gw.id }"]
  }

  tags {
      Name = "${ var.vpc_name }-monitoring"
  }
}

resource "aws_iam_role" "monitoring" {
  name = "${ var.vpc_name }-monitoring"
  assume_role_policy = "${ file("${path.module}/monitoring/role_assume_policy.yml") }"
  assume_role_policy = "${ data.template_file.monitoring_role_assume_policy.rendered }"
  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "monitoring" {
  name = "${ var.vpc_name }-monitoring"
  role = "${ aws_iam_role.monitoring.id }"

  policy = "${ data.template_file.monitoring_role_policy.rendered }"
  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "template_file" "main" {
    template = "${ file("${path.module}/cloudinit.yml") }"
    vars {
        hostname = "${ var.name }-infra.${ var.private_domain_name }"
    }
}

