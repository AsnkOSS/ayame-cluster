resource "hcloud_load_balancer" "this" {
  name               = var.name
  load_balancer_type = var.lb_type
  location           = var.location
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  subnet_id        = var.subnet_id
  ip               = var.private_ip
}

resource "hcloud_load_balancer_target" "servers" {
  for_each = var.target_server_map

  type             = "server"
  load_balancer_id = hcloud_load_balancer.this.id
  server_id        = each.value
}
