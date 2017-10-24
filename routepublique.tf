resource "aws_internet_gateway" "gwBD" {
  vpc_id = "${aws_vpc.mainBD.id}"

  tags {
    Name = "mainBD"
  }
}

resource "aws_route_table" "BD" {
  vpc_id = "${aws_vpc.mainBD.id}"

  route {
    cidr_block = "172.23.0.0/16"
    gateway_id = "${aws_internet_gateway.gwBD.id}"
  }

  tags {
    Name = "mainBD"
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
