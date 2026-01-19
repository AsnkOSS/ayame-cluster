variable "cluster_name" {
  type    = string
  default = "ayame"
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
  default = "./secrets/ayame-cluster.pub"
}

variable "ssh_private_key_path" {
  type    = string
  default = "./secrets/ayame-cluster.key"
}

variable "server_image" {
  type    = string
  default = "rocky-10"
}

variable "servers" {
  description = "All servers in the cluster"
  type = map(object({
    role        = string
    private_ip  = string
    server_type = string
  }))
  default = {
    "control-1" = { role = "control", private_ip = "10.0.0.11", server_type = "cx43" }
    "control-2" = { role = "control", private_ip = "10.0.0.12", server_type = "cx43" }
    "control-3" = { role = "control", private_ip = "10.0.0.13", server_type = "cx43" }
    "worker-1"  = { role = "worker", private_ip = "10.0.0.21", server_type = "cx53" }
    "worker-2"  = { role = "worker", private_ip = "10.0.0.22", server_type = "cx53" }
    "worker-3"  = { role = "worker", private_ip = "10.0.0.23", server_type = "cx53" }
    "worker-4"  = { role = "worker", private_ip = "10.0.0.24", server_type = "cx53" }
    "worker-5"  = { role = "worker", private_ip = "10.0.0.25", server_type = "cx53" }
  }
}

variable "lb_type" {
  type    = string
  default = "lb11"
}

variable "lb_internal_private_ip" {
  type    = string
  default = "10.0.0.2"
}

variable "lb_external_private_ip" {
  type    = string
  default = "10.0.0.3"
}
