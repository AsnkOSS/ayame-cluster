terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "name" { type = string }

variable "network_ip_range" { type = string }
variable "subnet_ip_range" { type = string }
variable "network_zone" { type = string }
