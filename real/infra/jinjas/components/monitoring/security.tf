
#### IAM role

resource "aws_iam_instance_profile" "monitoring" {
  name = "monitoring"
  role = "${ aws_iam_role.monitoring.name }"
}

resource "aws_iam_role" "monitoring" {
  name = "monitoring"
  assume_role_policy = "${ data.aws_iam_policy_document.assume_role.json }"
}

resource "aws_iam_role_policy" "monitoring" {
  name    = "monitoring"
  role    = "${ aws_iam_role.monitoring.id }"
  policy  = "${ data.aws_iam_policy_document.monitoring.json }"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "monitoring" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricStatistics"
      ,"cloudwatch:ListMetrics"
      ,"cloudwatch:PutMetricData"
      ,"ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}

#### monitoring SG

resource "aws_security_group" "monitoring" {
  name        = "{{ vpc.name }}-monitoring"
  description = "monitoring master servers"
  vpc_id = "${ aws_vpc.main.id }"
  tags {
      Name = "{{ vpc.name }}-monitoring"
  }
}

resource "aws_security_group_rule" "inbound_allow_grafana" {
  type        = "ingress"
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  source_security_group_id = "${ aws_security_group.gw.id }"
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
  security_group_id = "${ aws_security_group.main.id }"
}

