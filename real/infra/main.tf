
provider "aws" {
  access_key = "${ var.access_key }"
  secret_key = "${ var.secret_key }"
  region     = "${ var.geo }"
}

resource "aws_key_pair" "main" {
    key_name   = "${ var.vpc_name }-main"
    public_key = "${ var.public_key }"
}


