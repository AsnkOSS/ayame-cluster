locals {
  cps = [
    for i, n in var.control_planes : merge(n, {
      etcd_member_name = "etcd${i + 1}"
    })
  ]
}

resource "local_file" "hosts_yaml" {
  filename = var.inventory_path
  content = templatefile("${path.module}/templates/hosts.yaml.tmpl", {
    control_planes       = local.cps
    workers              = var.workers
    ansible_user         = var.ansible_user
    ssh_private_key_file = var.ssh_private_key_file
  })
}

resource "null_resource" "apply" {
  count = var.run_kubespray ? 1 : 0

  triggers = merge({
    inventory_sha = filesha256(local_file.hosts_yaml.filename)
  }, var.extra_triggers)

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-lc"]
    command     = <<-BASH
      set -euo pipefail
      uv run ansible-playbook -i "${var.inventory_path}" -b -v cluster.yml
    BASH
  }
}
