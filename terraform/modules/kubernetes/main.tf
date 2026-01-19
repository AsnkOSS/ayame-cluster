terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

resource "local_file" "k0sctl_config" {
  content = templatefile("${path.module}/templates/config.yaml.tmpl", {
    cluster_name           = var.cluster_name
    ssh_key_path           = var.ssh_key_path
    servers                = var.server_public_ips
    controller_ips         = var.controller_private_ips
    lb_internal_private_ip = var.lb_internal_private_ip
    lb_internal_public_ip  = var.lb_internal_public_ip
    lb_external_private_ip = var.lb_external_private_ip
    lb_external_public_ip  = var.lb_external_public_ip
  })
  filename = "${path.cwd}/kubernetes/config.yaml"
}
