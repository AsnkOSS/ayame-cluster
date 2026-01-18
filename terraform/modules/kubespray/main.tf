terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

resource "local_file" "kubespray_inventory" {
  content = templatefile("${path.module}/templates/inventory.ini.tmpl", {
    control_planes = [for s, server in var.servers : {
      name             = "${var.cluster_name}-s"
      public_ip        = var.server_ipv4[s]
      private_ip       = server.private_ip
      etcd_member_name = "etcd-${s}"
    } if server.role == "master"]

    workers = [for s, server in var.servers : {
      name       = "${var.cluster_name}-s"
      public_ip  = var.server_ipv4[s]
      private_ip = server.private_ip
    } if server.role == "node"]

    ansible_user         = var.ansible_user
    ssh_private_key_path = var.ssh_private_key_path
  })

  filename = "${path.root}/inventory/${var.cluster_name}/inventory.ini"
}

resource "null_resource" "deploy_k8s_with_kubespray" {
  depends_on = [local_file.kubespray_inventory]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.root}/kubespray
      ansible-playbook -i ${path.root}/inventory/${var.cluster_name}/inventory.ini --become --become-user=root cluster.yml
    EOT
  }
}
