module "network" {
  source           = "./modules/network"
  name             = "${var.cluster_name}-network"
  network_ip_range = var.network_ip_range
  subnet_ip_range  = var.subnet_ip_range
  network_zone     = var.network_zone
}

module "ssh_key" {
  source     = "./modules/ssh_key"
  name       = var.cluster_name
  public_key = file(var.ssh_public_key_path)
}

module "servers" {
  source       = "./modules/servers"
  cluster_name = var.cluster_name
  location     = var.location
  image        = var.server_image
  server_type  = var.server_type

  ssh_key_id = module.ssh_key.id

  subnet_id = module.network.subnet_id
  servers   = var.servers
}

module "loadbalancer" {
  source   = "./modules/loadbalancer"
  name     = "${var.cluster_name}-lb"
  lb_type  = var.lb_type
  location = var.location

  subnet_id  = module.network.subnet_id
  private_ip = var.lb_private_ip

  target_server_map = module.servers.server_ids
}

module "firewall" {
  source     = "./modules/firewall"
  name       = "${var.cluster_name}-firewall"
  server_ids = values(module.servers.server_ids)

  rules = [
    {
      direction  = "in"
      protocol   = "icmp"
      port       = null
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "22"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]
}
