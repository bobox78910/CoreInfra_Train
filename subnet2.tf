resource "aws_subnet" "mainBDSUB2" {
  vpc_id     = "${aws_vpc.mainBD.id}"
  cidr_block = "172.23.1.0/24"

  tags {
    Name = "MainBD"
  }
}