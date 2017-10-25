terraform {
  backend "S3" {
   bucket = "${var.bucketBD}"
   key = "vpc/terraform.tfstate"
   region= "${var.regionBD}"
   }
 }
 
 provider "aws" {
 region     = "${var.regionBD}"
  }
resource "aws_vpc" "mainBD" {
  cidr_block       = "${var.BlockBD["mainbloc"]}"
  #instance_tenancy = "dedicated"

  tags {
    Name = "mainBD"
  }
}

resource "aws_subnet" "mainBDSUB1" {
  availability_zone = "eu-west-1a"
  vpc_id     = "${aws_vpc.mainBD.id}"
  #map_public_ip_on_launch = true
  cidr_block = "${var.BlockBD["blocsub1"]}"

  tags {
    Name = "MainBDSUB1"
  }
}

resource "aws_subnet" "mainBDSUB2" {
  availability_zone = "eu-west-1b"
  vpc_id     = "${aws_vpc.mainBD.id}"
  #map_public_ip_on_launch = true
  cidr_block = "${var.BlockBD["blocsub2"]}"

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

output "vpc_id" {  
  value = "${aws_vpc.mainBD.id}" 
}

output "sub1_id" {  
  value = "${aws_subnet.mainBDSUB1.id}" 
}

output "sub2_id" {  
  value = "${aws_subnet.mainBDSUB2.id}" 
}
