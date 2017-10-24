
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
  name        = "allow_all"  
  description = "Allow all inbound traffic"  
  vpc_id = "${aws_vpc.mainBD.id}"
  ingress {    
    from_port   = 22    
    to_port     = 22    
    protocol    = "tcp"    
    cidr_blocks = ["0.0.0.0/0"]  } 
  => ADD INGRESS FOR PORT 80  
  egress {    
    from_port       = 0    
    to_port         = 0    
    protocol        = "-1"    
    cidr_blocks     = ["0.0.0.0/0"]  } }

data "template_file" "BD" {  
  template = "${file("${path.module}/userdata.tpl")}"
  vars {    
    username = "YYYYYYYYYYYYYYYYYYY"
    }
}

resource "aws_instance" "webBD" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "=>Manual import"
  vpc_security_group_ids = "${aws_security_group.allow_all.id}"

  tags {
    Name = "HelloBDWorld"
  }
}

output "public_ip" {  
  value = "${aws_instance.webBD.public_ip}" 
  }
