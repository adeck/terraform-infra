
provider "aws" {
  access_key = "${ var.access_key }"
  secret_key = "${ var.secret_key }"
  region     = "${ var.geo }"
}

resource "aws_vpc" "main" {
    cidr_block       = "${ var.vpc_cidr }"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
      Name = "${ var.vpc_name }"
    }
}

resource "aws_subnet" "main" {
    vpc_id            = "${ aws_vpc.main.id }"
    cidr_block        = "${ cidrsubnet(aws_vpc.main.cidr_block, 8, 1) }"
    tags {
      Name = "adeck testing subnet"
    }
}

