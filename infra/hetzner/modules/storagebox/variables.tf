variable "name" {
  description = "Storage Box name"
  type        = string
}

variable "storage_box_type" {
  description = "Storage Box type, e.g. bx11/bx21..."
  type        = string
}

variable "location" {
  description = "Location name, e.g. fsn1/nbg1/hel1..."
  type        = string
}

variable "password" {
  description = "Initial password (required for creation)"
  type        = string
  sensitive   = true
}

variable "delete_protection" {
  description = "Whether delete protection is enabled"
  type        = bool
  default     = false
}

variable "access_settings" {
  description = "Access settings for the Storage Box"
  type = object({
    reachable_externally = optional(bool)
    samba_enabled        = optional(bool)
    ssh_enabled          = optional(bool)
    webdav_enabled       = optional(bool)
    zfs_enabled          = optional(bool)
  })
  default = null
}
