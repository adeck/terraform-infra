
resource "aws_vpc" "main" {
    cidr_block       = "${ var.vpc_cidr }"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "${ var.vpc_name }"
        Description = "Managed by terraform"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${ aws_vpc.main.id }"
}

resource "aws_main_route_table_association" "main" {
    vpc_id         = "${ aws_vpc.main.id }"
    route_table_id = "${ aws_route_table.main.id }"
}

resource "aws_route_table" "main" {
  vpc_id = "${ aws_vpc.main.id }"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${ aws_internet_gateway.main.id }"
  }

  tags {
    Name = "${ var.vpc_name }-main"
    Description = "Managed by terraform"
  }
}

resource "aws_subnet" "infra" {
    vpc_id = "${ aws_vpc.main.id }"
    cidr_block = "${ cidrsubnet(aws_vpc.main.cidr_block, 8, 1) }"
    map_public_ip_on_launch = true
    tags {
        Name = "infra"
        Description = "Managed by terraform"
    }
}

