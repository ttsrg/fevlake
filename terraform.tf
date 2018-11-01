provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-1"
}

resource "aws_key_pair" "liquidpredator_hw5_key" {
  key_name = "liquidpredator_hw5_key"
  public_key = "${var.ssh_pub_key}"
}

resource "aws_security_group" "liquidpredator_hw5_sg" {
  name = "liquidpredator_hw5_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    cidr_blocks = "${var.ssh_secure_subnet}"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  
  ingress {
    cidr_blocks = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

resource "aws_instance" "frontend" {
  ami = "ami-0e32ec5bc225539f5"
  instance_type = "t2.micro"
  key_name = "liquidpredator_hw5_key"
  associate_public_ip_address = true
  security_groups = ["liquidpredator_hw5_sg"]
  subnet_id = "${var.vpc_id}"

  provisioner "remote-exec" {
    inline = ["apt update && apt install -y python2.7-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1"]
  }
}

resource "aws_instance" "backend" { 
  ami = "ami-0e32ec5bc225539f5"
  instance_type = "t2.micro"
  key_name = "liquidpredator_hw5_key"
  associate_public_ip_address = true
  security_groups = ["liquidpredator_hw5_sg"]
  subnet_id = "${var.vpc_id}"

  provisioner "remote-exec" {
    inline = ["apt update && apt install -y python2.7-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1"]
  }
}

resource "aws_route53_record" "liquidpredator_hw5__dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${front.public_ip}"]
}

resource "null_resource" "liquidpredator_hw5" {
  provisioner "local-exec" {
    command = "ansible-playbook -i terraform-inventory --private-key ${var.ssh_key} frontend.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i terraform-inventory --private-key ${var.ssh_key} backend.yml"
  }
}
