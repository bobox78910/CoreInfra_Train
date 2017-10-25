resource "aws_subnet" "mainBDSUB1" {
  availability_zone = "eu-west-1a"
  vpc_id     = "${aws_vpc.mainBD.id}"
  map_public_ip_on_launch = true
  cidr_block = "172.23.0.0/24"

  tags {
    Name = "MainBDSUB1"
  }
}
