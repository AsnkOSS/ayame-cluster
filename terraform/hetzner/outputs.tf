output "network_id" {
  value = module.network.network_id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "server_ids" {
  value = module.servers.server_ids
}

output "lb_id" {
  value = module.loadbalancer.id
}

output "firewall_id" {
  value = module.firewall.id
}
