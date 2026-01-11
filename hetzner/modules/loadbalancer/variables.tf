variable "name" { type = string }
variable "lb_type" { type = string }
variable "location" { type = string }

variable "subnet_id" { type = string }
variable "private_ip" { type = string }

variable "target_server_map" {
  type = map(string)
}

variable "services" {
  description = "Load balancer services keyed by name"
  type = map(object({
    protocol         = string
    listen_port      = optional(number)
    destination_port = optional(number)
    proxyprotocol    = optional(bool, false)

    http = optional(object({
      sticky_sessions = optional(bool, false)
      cookie_name     = optional(string)
      cookie_lifetime = optional(number)
      redirect_http   = optional(bool)
    }))

    health_check = optional(object({
      protocol = string
      port     = optional(number)
      interval = optional(number)
      timeout  = optional(number)
      retries  = optional(number)

      http = optional(object({
        domain       = optional(string)
        path         = optional(string)
        response     = optional(string)
        tls          = optional(bool)
        status_codes = optional(list(string))
      }))
    }))
  }))

  default = {}
}
