output "server_ids" {
  value = { for k, s in hcloud_server.this : k => s.id }
}

output "server_names" {
  value = { for k, s in hcloud_server.this : k => s.name }
}

output "server_ipv4" {
  value = { for k, s in hcloud_server.this : k => s.ipv4_address }
}

output "server_ipv6" {
  value = { for k, s in hcloud_server.this : k => s.ipv6_address }
}
