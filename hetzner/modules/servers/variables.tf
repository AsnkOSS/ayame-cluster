terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "cluster_name" { type = string }
variable "location" { type = string }
variable "image" { type = string }
variable "server_type" { type = string }

variable "ssh_key_id" { type = string }

variable "subnet_id" { type = string }

variable "servers" {
  type = map(object({
    role       = string
    private_ip = string
  }))
}
