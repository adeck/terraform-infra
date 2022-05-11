
resource "aws_vpc" "main" {
<<<<<<< HEAD:infra/jinjas/components/site/networking.tf
    cidr_block       = "{{ vpc.cidr }}"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "{{ vpc.name }}"
=======
    cidr_block       = var.vpc_cidr
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = {
        Name = var.vpc_name
>>>>>>> d08617a (updates from two years ago that never got pushed out):real/infra/networking.tf
        Description = "Managed by terraform"
    }
}

### dmz setup

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "main" {
<<<<<<< HEAD:infra/jinjas/components/site/networking.tf
    allocation_id = "${ aws_eip.nat.id }"
    subnet_id     = "${ aws_subnet.dmz.id }"
=======
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.dmz.id
>>>>>>> d08617a (updates from two years ago that never got pushed out):real/infra/networking.tf
}

resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_route_table_association" "dmz" {
    subnet_id      = aws_subnet.dmz.id
    route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

<<<<<<< HEAD:infra/jinjas/components/site/networking.tf
  tags {
    Name = "{{ vpc.name }}-dmz"
=======
  tags = {
    Name = "dmz-${ var.vpc_name }"
>>>>>>> d08617a (updates from two years ago that never got pushed out):real/infra/networking.tf
    Description = "Managed by terraform"
  }
}

resource "aws_subnet" "dmz" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
    tags = {
        Name = "dmz-${ var.vpc_name }"
        Description = "Managed by terraform"
    }
}

### infrastructure host subnet setup

resource "aws_route_table_association" "infra" {
    subnet_id      = aws_subnet.infra.id
    route_table_id = aws_route_table.infra.id
}

resource "aws_route_table" "infra" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

<<<<<<< HEAD:infra/jinjas/components/site/networking.tf
  tags {
    Name = "{{ vpc.name }}-infra"
=======
  tags = {
    Name = "infra-${ var.vpc_name }"
>>>>>>> d08617a (updates from two years ago that never got pushed out):real/infra/networking.tf
    Description = "Managed by terraform"
  }
}

resource "aws_subnet" "infra" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
    tags = {
        Name = "infra-${ var.vpc_name }"
        Description = "Managed by terraform"
    }
}

