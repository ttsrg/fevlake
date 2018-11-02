variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "ssh_secure_subnet" { type = "list" }
variable "ssh_key" {}
variable "ssh_pub_key" {}
variable "zone_id" {}
variable "admin_mail" {}
variable "domain" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-central-1"
}

resource "aws_key_pair" "lphw5_key" {
  key_name = "lphw5_key"
  public_key = "${file(var.ssh_pub_key)}"
}

resource "aws_route53_record" "lphw5_dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.frontend.public_ip}"]
}

