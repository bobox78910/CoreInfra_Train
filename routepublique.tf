resource "aws_internet_gateway" "gwBD" {
  vpc_id = "${aws_vpc.mainBD.id}"

  tags {
    Name = "mainBDGW"
  }
}

resource "aws_route_table" "BD" {
  depends_on = ["aws_subnet.mainBDSUB1", "aws_subnet.mainBDSUB2"]
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
