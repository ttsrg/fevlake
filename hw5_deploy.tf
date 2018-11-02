resource "null_resource" "liquidpredator_hw5_deploy" {
  provisioner "local-exec" {
    command = "touch frontvars.yml && :> frontvars.yml && echo 'set_backend_ip: \"${aws_instance.backend.public_ip}\"' >> frontvars.yml && echo 'set_domain_name: \"${var.domain}\"' >> frontvars.yml && echo 'certbot_admin_email: \"${var.admin_mail}\"' >> frontvars.yml"
  }

  provisioner "local-exec" {
    command = "touch backvars.yml && :> backvars.yml && echo 'php_fpm_listen_allowed_clients: \"${aws_instance.frontend.public_ip}\"' >> backvars.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i terraform-inventory --private-key ${var.ssh_key} frontend.yml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i terraform-inventory --private-key ${var.ssh_key} backend.yml"
  }
}
