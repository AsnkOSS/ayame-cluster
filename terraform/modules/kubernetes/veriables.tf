variable "cluster_name" {
  type = string
}

variable "ssh_key_path" {
  type = string
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

variable "servers" {
  type = map(object({
    role       = string
    private_ip = string
    public_ip  = string
  }))
}
