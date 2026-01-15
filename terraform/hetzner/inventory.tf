locals {
  ansible_user    = "root"
  ssh_private_key = pathexpand("./secrets/ayame-cluster.key")

  control_planes = [
    for i, s in hcloud_server.control_plane : {
      name             = "cp-${i + 1}"
      public_ip        = s.ipv4_address
      private_ip       = s.private_net[0].ip
      etcd_member_name = "etcd${i + 1}"
    }
  ]

  workers = [
    for i, s in hcloud_server.worker : {
      name       = "wk-${i + 1}"
      public_ip  = s.ipv4_address
      private_ip = s.private_net[0].ip
    }
  ]
}

resource "local_file" "inventory_ini" {
  filename = "${path.root}/cluster/inventory.ini"
  content = templatefile("${path.root}/terraform/templates/inventory.ini.tmpl", {
    control_planes  = local.control_planes
    workers         = local.workers
    ansible_user    = local.ansible_user
    ssh_private_key = local.ssh_private_key
  })
}
