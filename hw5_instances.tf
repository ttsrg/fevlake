resource "aws_instance" "frontend" {
  ami = "ami-086a09d5b9fa35dc7"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.lphw5_key.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.lphw5_sg_front.name}"]

  provisioner "remote-exec" {
    inline = ["sudo cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/"]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(var.ssh_key)}"
    }
  }

  provisioner "remote-exec" {
    inline = ["apt update && apt install -y python2.7-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1"]
  }

}

resource "aws_instance" "backend" {
  ami = "ami-086a09d5b9fa35dc7"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.lphw5_key.key_name}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.lphw5_sg_back.name}"]

  provisioner "remote-exec" {
    inline = ["sudo cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/"]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file(var.ssh_key)}"
    }
  }

  provisioner "remote-exec" {
    inline = ["apt update && apt install -y python2.7-minimal && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1"]
  }
}
