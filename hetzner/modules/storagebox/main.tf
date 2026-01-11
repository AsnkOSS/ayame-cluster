terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

resource "hcloud_storage_box" "this" {
  name             = var.name
  storage_box_type = var.storage_box_type
  location         = var.location
  password         = var.password

  delete_protection = var.delete_protection
  access_settings   = var.access_settings
}
