resource "aws_subnet" "mainBDSUB2" {
  vpc_id     = "${aws_vpc.mainBD.id}"
  map_public_ip_on_launch = true
  cidr_block = "172.23.1.0/24"

  tags {
    Name = "MainBDSUB2"
  }
}
