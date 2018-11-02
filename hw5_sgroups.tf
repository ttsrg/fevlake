resource "aws_security_group" "lphw5_sg_front" {
  name = "lphw5_sg_front"
}

resource "aws_security_group_rule" "front_in_ssh" {
  type = "ingress"
  cidr_blocks = "${var.ssh_secure_subnet}"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group_rule" "front_in_http" {
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group_rule" "front_in_https" {
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group_rule" "front_out_http" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group_rule" "front_out_https" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group_rule" "front_out_goapi" {
  type = "egress"
  cidr_blocks = ["${aws_instance.backend.public_ip}/32"]
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group_rule" "front_out_phpapi" {
  type = "egress"
  cidr_blocks = ["${aws_instance.backend.public_ip}/32"]
  from_port = 9090
  to_port = 9090
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_front.id}"
}

resource "aws_security_group" "lphw5_sg_back" {
  name = "lphw5_sg_back"
}

resource "aws_security_group_rule" "back_in_ssh" {
  type = "ingress"
  cidr_blocks = "${var.ssh_secure_subnet}"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}

resource "aws_security_group_rule" "back_in_goapi" {
  type = "ingress"
  cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}

resource "aws_security_group_rule" "back_in_phpapi" {
  type = "ingress"
  cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
  from_port = 9090
  to_port = 9090
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}

resource "aws_security_group_rule" "back_out_http" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}

resource "aws_security_group_rule" "back_out_https" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}

resource "aws_security_group_rule" "back_out_goapi" {
  type = "egress"
  cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}

resource "aws_security_group_rule" "back_out_phpapi" {
  type = "egress"
  cidr_blocks = ["${aws_instance.frontend.public_ip}/32"]
  from_port = 9090
  to_port = 9090
  protocol = "tcp"
  security_group_id = "${aws_security_group.lphw5_sg_back.id}"
}
