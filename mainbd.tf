
provider "aws" {
 region     = "eu-west-1"
  }
resource "aws_vpc" "mainBD" {
  cidr_block       = "172.23.0.0/16"
  #instance_tenancy = "dedicated"

  tags {
    Name = "mainBD"
  }
}

resource "aws_subnet" "mainBDSUB1" {
  availability_zone = "eu-west-1a"
  vpc_id     = "${aws_vpc.mainBD.id}"
  #map_public_ip_on_launch = true
  cidr_block = "172.23.0.0/24"

  tags {
    Name = "MainBDSUB1"
  }
}

resource "aws_subnet" "mainBDSUB2" {
  availability_zone = "eu-west-1b"
  vpc_id     = "${aws_vpc.mainBD.id}"
  #map_public_ip_on_launch = true
  cidr_block = "172.23.1.0/24"

  tags {
    Name = "MainBDSUB2"
  }
}
resource "aws_internet_gateway" "gwBD" {
  vpc_id = "${aws_vpc.mainBD.id}"

  tags {
    Name = "mainBDGW"
  }
}

resource "aws_route_table" "BD" {
  vpc_id = "${aws_vpc.mainBD.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gwBD.id}"
  }

  tags {
    Name = "mainBDRoute"
  }
}

resource "aws_route_table_association" "BDSUB1" {
  subnet_id      = "${aws_subnet.mainBDSUB1.id}"
  route_table_id = "${aws_route_table.BD.id}"
}
resource "aws_route_table_association" "BDSUB2" {
  subnet_id      = "${aws_subnet.mainBDSUB2.id}"
  route_table_id = "${aws_route_table.BD.id}"
}
