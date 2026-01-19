terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

resource "hcloud_server" "this" {
  for_each = var.servers

  name        = "${var.cluster_name}-${each.key}"
  location    = var.location
  image       = var.image
  server_type = each.value.server_type

  ssh_keys = [var.ssh_key_id]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  labels = {
    cluster = var.cluster_name
    role    = each.value.role
  }
}

resource "hcloud_server_network" "this" {
  for_each  = var.servers
  server_id = hcloud_server.this[each.key].id
  subnet_id = var.subnet_id
  ip        = each.value.private_ip
}
