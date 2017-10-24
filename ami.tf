data "aws_ami" "UbuntuBD" {
  most_recent      = true
 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualisation-type"
    values = ["hvm"]
  }

  owners     = ["099720109477"]
}
