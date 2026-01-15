variable "inventory_path" {
  type        = string
  description = "Absolute or repo-relative path to write hosts.yaml"
}

variable "ansible_user" {
  type    = string
  default = "root"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Path to SSH private key used by ansible"
}

variable "control_planes" {
  type = list(object({
    name       = string
    public_ip  = string
    private_ip = string
  }))
}

variable "workers" {
  type = list(object({
    name       = string
    public_ip  = string
    private_ip = string
  }))
}

variable "run_kubespray" {
  type    = bool
  default = false
}

variable "kubespray_dir" {
  type        = string
  default     = ""
  description = "Path to kubespray directory (required if run_kubespray=true)"
}

variable "extra_triggers" {
  type        = map(string)
  default     = {}
  description = "Extra triggers to force re-run, e.g. hashes of group_vars files"
}
