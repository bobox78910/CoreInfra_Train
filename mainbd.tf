
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
} 

resource "aws_security_group" "allow_all" {  
  name        = "allow_BD"  
  description = "Allow all inbound traffic"  
  vpc_id = "${aws_vpc.mainBD.id}"
  ingress {    
    from_port   = 22    
    to_port     = 22    
    protocol    = "tcp"    
    cidr_blocks = ["0.0.0.0/0"] 
    } 
 # => ADD INGRESS FOR PORT 80  
  egress {    
    from_port       = 0    
    to_port         = 0    
    protocol        = "-1"    
    cidr_blocks     = ["0.0.0.0/0"]
    } 
  }

data "template_file" "BD" {  
  template = "${file("${path.module}/userdata.tpl")}"
  vars {    
    username = "root"
    }
}

resource "aws_instance" "webBD" {
  ami           = "${data.aws_ami.ubuntu.id}"
  availability_zone = "${var.zones[0]}"
  instance_type = "t2.micro"
  key_name = "BDkey"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  user_data = "${data.template_file.BD.rendered}" 
  subnet_id = "${aws_subnet.mainBDSUB1.id}"
  associate_public_ip_address = true

  tags {
    Name = "HelloBDWorld"
  }
}

output "public_ip" {  
  value = "${aws_instance.webBD.public_ip}" 
  }
