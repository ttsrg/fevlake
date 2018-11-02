resource "aws_security_group" "lphw5_sg_ssh" {
  name = "lphw5_sg_ssh"

  ingress {
    cidr_blocks = "${var.ssh_secure_subnet}"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
}

resource "aws_security_group" "lphw5_sg_http_in" {
  name = "lphw5_sg_http_in"

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
}

resource "aws_security_group" "lphw5_sg_http_out" {
  name = "lphw5_sg_http_out"

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
}

resource "aws_security_group" "lphw5_sg_fr_to_ba" {
  name = "lphw5_sg_fr_to_ba"

  egress {
    cidr_blocks = ["${aws_instance.backend.public_ip}/32"]
#    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["${aws_instance.backend.public_ip}/32"]
#    cidr_blocks = ["0.0.0.0/0"]
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
  }
}

resource "aws_security_group" "lphw5_sg_ba_fr_fr" {
  name = "lphw5_sg_ba_fr_fr"

  ingress {
    cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
#    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
#    cidr_blocks = ["0.0.0.0/0"]
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
  }
}

resource "aws_security_group" "lphw5_sg_ba_to_fr" {
  name = "lphw5_sg_ba_to_fr"

  egress {
    cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
#    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
#    cidr_blocks = ["0.0.0.0/0"]
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
  }
}
