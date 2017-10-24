resource "aws_subnet" "mainBDSUB1" {
  vpc_id     = "${aws_vpc.mainBD.id}"
  map_public_ip_on_launch = true
  cidr_block = "172.23.0.0/24"

  tags {
    Name = "MainBD"
  }
}
