variable "cluster_name" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "server_public_ips" {
  type = map(string)
}

variable "controller_private_ips" {
  type = list(string)
}

variable "lb_internal_private_ip" {
  type = string
}

variable "lb_internal_public_ip" {
  type = string
}

variable "lb_external_private_ip" {
  type = string
}

variable "lb_external_public_ip" {
  type = string
}
