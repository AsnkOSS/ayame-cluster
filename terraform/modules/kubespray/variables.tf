variable "cluster_name" {
  type = string
}

variable "ansible_user" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "servers" {
  type = map(object({
    role       = string
    private_ip = string
  }))
}

variable "server_ipv4" {
  type = map(string)
}

variable "server_ipv6" {
  type = map(string)
}
