variable "aws_access_key" {}
variable "aws_secret_key" {}
#variable "vpc_id" {}
variable "ssh_secure_subnet" { type = "list" }
variable "ssh_key" {}
variable "ssh_pub_key" {}
variable "zone_id" {}
variable "admin_mail" {}
variable "domain" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-2"
}

resource "aws_key_pair" "liquidpredator_hw5_key" {
  key_name = "liquidpredator_hw5_key"
  public_key = "${var.ssh_pub_key}"
}

resource "aws_security_group" "liquidpredator_hw5_sg_front" {
  name = "liquidpredator_hw5_sg_front"
#  vpc_id = "${var.vpc_id}"

  ingress {
    cidr_blocks = "${var.ssh_secure_subnet}"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
  }
}

resource "aws_instance" "frontend" {
  ami = "ami-0e32ec5bc225539f5"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.liquidpredator_hw5_key.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.liquidpredator_hw5_sg_front.name}"]
#  subnet_id = "${var.vpc_id}"

  provisioner "remote-exec" {
    inline = ["sudo cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/"]
    connection {
      type     = "ssh"
      user     = "ubuntu"
#      private_key = "file(${var.ssh_key})"
    }
  }

  provisioner "remote-exec" {
    inline = ["apt update && apt install -y python2.7-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1"]
  }

}

resource "aws_security_group" "liquidpredator_hw5_sg_back" {
  name = "liquidpredator_hw5_sg_back"
#  vpc_id = "${var.vpc_id}"

  ingress {
    cidr_blocks = "${var.ssh_secure_subnet}"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  
  ingress {
    cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
  }
}

resource "aws_instance" "backend" { 
  ami = "ami-0e32ec5bc225539f5"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.liquidpredator_hw5_key.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.liquidpredator_hw5_sg_back.name}"]
#  subnet_id = "${var.vpc_id}"

  provisioner "remote-exec" {
    inline = ["sudo cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/"]
    connection {
      type     = "ssh"
      user     = "ubuntu"
#      private_key = "file(${var.ssh_key})"
    }
  }

  provisioner "remote-exec" {
    inline = ["apt update && apt install -y python2.7-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1"]
  }
}

resource "aws_route53_record" "liquidpredator_hw5_dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.frontend.public_ip}"]
}

resource "null_resource" "liquidpredator_hw5" {
  provisioner "local-exec" {
    command = "touch frontvars.yml && :> frontvars.yml && echo 'set_backend_ip: \"${aws_instance.backend.public_ip}\"' >> frontvars.yml && echo 'set_domain_name: \"${var.domain}\"' >> frontvars.yml && echo 'certbot_admin_email: \"${var.admin_mail}\"' >> frontvars.yml"
  }

  provisioner "local-exec" {
    command = "touch backvars.yml && :> backvars.yml && echo 'php_fpm_listen: \"${aws_instance.backend.public_ip}:9090\"' >> backvars.yml && echo 'php_fpm_listen_allowed_clients: \"${aws_instance.frontend.public_ip}\"' >> backvars.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i terraform-inventory --private-key ${var.ssh_key} frontend.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i terraform-inventory --private-key ${var.ssh_key} backend.yml"
  }
}
