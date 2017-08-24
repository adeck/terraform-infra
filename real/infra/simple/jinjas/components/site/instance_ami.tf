
data "aws_ami" "main" {
  owners = ["self"]
  filter {
    name   = "name"
    values = ["debian-stretch-base"]
  }
}

