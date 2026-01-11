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
  use_private_ip   = true
}

resource "hcloud_load_balancer_service" "this" {
  for_each = var.services

  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = lower(each.value.protocol)

  listen_port      = try(each.value.listen_port, null)
  destination_port = try(each.value.destination_port, null)

  proxyprotocol = try(each.value.proxyprotocol, false)

  dynamic "http" {
    for_each = try(each.value.http, null) == null ? [] : [each.value.http]
    content {
      sticky_sessions = try(http.value.sticky_sessions, null)
      cookie_name     = try(http.value.cookie_name, null)
      cookie_lifetime = try(http.value.cookie_lifetime, null)
      redirect_http   = try(http.value.redirect_http, null)
    }
  }

  dynamic "health_check" {
    for_each = try(each.value.health_check, null) == null ? [] : [each.value.health_check]
    content {
      protocol = lower(health_check.value.protocol)
      port     = try(health_check.value.port, null)

      interval = try(health_check.value.interval, null)
      timeout  = try(health_check.value.timeout, null)
      retries  = try(health_check.value.retries, null)

      dynamic "http" {
        for_each = try(health_check.value.http, null) == null ? [] : [health_check.value.http]
        content {
          domain       = try(http.value.domain, null)
          path         = try(http.value.path, null)
          response     = try(http.value.response, null)
          tls          = try(http.value.tls, null)
          status_codes = try(http.value.status_codes, null)
        }
      }
    }
  }
}
