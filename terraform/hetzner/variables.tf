variable "cluster_name" {
  type    = string
  default = "ayame-cluster"
}

variable "location" {
  type    = string
  default = "fsn1"
}

variable "network_zone" {
  type    = string
  default = "eu-central"
}

variable "network_ip_range" {
  type    = string
  default = "10.0.0.0/8"
}

variable "subnet_ip_range" {
  type    = string
  default = "10.0.0.0/24"
}

variable "ssh_public_key_path" {
  type    = string
  default = "./terraform/hetzner/ayame-cluster.pub"
}

variable "server_image" {
  type    = string
  default = "rocky-10"
}

variable "server_type" {
  type    = string
  default = "cx53"
}

variable "servers" {
  description = "All servers in the cluster"
  type = map(object({
    role       = string # master | node
    private_ip = string
  }))
  default = {
    "master-1" = { role = "master", private_ip = "10.0.0.11" }
    "master-2" = { role = "master", private_ip = "10.0.0.12" }
    "master-3" = { role = "master", private_ip = "10.0.0.13" }
    "node-1"   = { role = "node", private_ip = "10.0.0.21" }
    "node-2"   = { role = "node", private_ip = "10.0.0.22" }
  }
}

variable "lb_type" {
  type    = string
  default = "lb11"
}

variable "lb_private_ip" {
  type    = string
  default = "10.0.0.2"
}
