terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "name" { type = string }
variable "lb_type" { type = string }
variable "location" { type = string }

variable "subnet_id" { type = string }
variable "private_ip" { type = string }

variable "target_server_map" {
  type = map(string)
}
