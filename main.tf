terraform {
  backend "s3" {
    bucket = "asai-terraform-state"
    key    = "ayame-cluster.tfstate"
    region = "eu-central-1"

    endpoints = {
      s3 = "https://fsn1.your-objectstorage.com"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

module "kubernetes" {
  source  = "hcloud-k8s/kubernetes/hcloud"
  version = "3.20.1"

  cluster_name = "ayame"
  hcloud_token = var.hcloud_token

  cluster_kubeconfig_path  = "./secrets/kubeconfig"
  cluster_talosconfig_path = "./secrets/talosconfig"

  cilium_gateway_api_enabled  = true
  cilium_hubble_enabled       = true
  cilium_hubble_relay_enabled = true
  cilium_hubble_ui_enabled    = true

  firewall_use_current_ipv4 = true
  firewall_use_current_ipv6 = false

  kube_api_load_balancer_enabled = true
  kube_api_hostname              = "ayame.cluster.asnk.io"

  control_plane_nodepools = [
    { name = "control", type = "cx43", location = "fsn1", count = 3 }
  ]
  worker_nodepools = [
    { name = "worker", type = "cx53", location = "fsn1", count = 5 }
  ]
}
