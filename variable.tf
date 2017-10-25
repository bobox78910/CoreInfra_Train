variable "regionBD" {
  type = "string"
  default = "eu-west-1"
}

variable "BlockBD" {
  type = "map"

  default = {
    mainbloc = "172.23.0.0/16"
    blocsub1 = "172.23.0.0/24"
    blocsub2 = "172.23.1.0/24"
  }
}

variable "zones" {
  default = ["eu-west-1a", "eu-west-1b"]
}
