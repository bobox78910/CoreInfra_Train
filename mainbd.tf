
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
