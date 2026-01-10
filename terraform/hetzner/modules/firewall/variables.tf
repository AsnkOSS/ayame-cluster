terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "name" { type = string }

variable "server_ids" {
  type = list(string)
}

variable "rules" {
  description = "Firewall rules"
  type = list(object({
    direction  = string
    protocol   = string
    port       = string
    source_ips = list(string)
  }))
}
