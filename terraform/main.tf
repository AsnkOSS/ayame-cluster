terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

module "network" {
  source           = "./modules/network"
  name             = "${var.cluster_name}-network"
  network_ip_range = var.network_ip_range
  subnet_ip_range  = var.subnet_ip_range
  network_zone     = var.network_zone
}

module "ssh_key" {
  source     = "./modules/ssh_key"
  name       = var.cluster_name
  public_key = file(var.ssh_public_key_path)
}

module "servers" {
  source       = "./modules/servers"
  cluster_name = var.cluster_name
  location     = var.location
  image        = var.server_image

  ssh_key_id = module.ssh_key.id

  subnet_id = module.network.subnet_id
  servers   = var.servers
}

module "internal-loadbalancer" {
  source   = "./modules/loadbalancer"
  name     = "${var.cluster_name}-internal-lb"
  lb_type  = var.lb_type
  location = var.location

  subnet_id  = module.network.subnet_id
  private_ip = var.lb_internal_private_ip

  enable_public_interface = false

  target_server_map = module.servers.server_ids

  services = {
    kube_api_server = {
      protocol         = "tcp"
      listen_port      = 6443
      destination_port = 6443
      health_check = {
        protocol = "tcp"
        port     = 6443
        interval = 10
        timeout  = 5
        retries  = 3
      }
    }
    k0s_api_server = {
      protocol         = "tcp"
      listen_port      = 9443
      destination_port = 9443
      health_check = {
        protocol = "tcp"
        port     = 9443
        interval = 10
        timeout  = 5
        retries  = 3
      }
    }
    konnectivity_service = {
      protocol         = "tcp"
      listen_port      = 8132
      destination_port = 8132
      health_check = {
        protocol = "tcp"
        port     = 8132
        interval = 10
        timeout  = 5
        retries  = 3
      }
    }
    kubelet_service = {
      protocol         = "tcp"
      listen_port      = 10250
      destination_port = 10250
      health_check = {
        protocol = "tcp"
        port     = 10250
        interval = 10
        timeout  = 5
        retries  = 3
      }
    }
    etcd_service = {
      protocol         = "tcp"
      listen_port      = 2380
      destination_port = 2380
      health_check = {
        protocol = "tcp"
        port     = 2380
        interval = 10
        timeout  = 5
        retries  = 3
      }
    }
  }
}

module "external-loadbalancer" {
  source   = "./modules/loadbalancer"
  name     = "${var.cluster_name}-external-lb"
  lb_type  = var.lb_type
  location = var.location

  subnet_id  = module.network.subnet_id
  private_ip = var.lb_external_private_ip

  enable_public_interface = true

  target_server_map = module.servers.server_ids

  services = {
    http_gateway = {
      protocol         = "tcp"
      listen_port      = 80
      destination_port = 30080
      health_check = {
        protocol = "http"
        port     = 30021
        interval = 10
        timeout  = 5
        retries  = 3
        http = {
          path         = "/healthz/ready"
          response     = ""
          tls          = false
          status_codes = ["200"]
        }
      }
    }
    https_gateway = {
      protocol         = "tcp"
      listen_port      = 443
      destination_port = 30443
      health_check = {
        protocol = "http"
        port     = 30021
        interval = 10
        timeout  = 5
        retries  = 3
        http = {
          path         = "/healthz/ready"
          response     = ""
          tls          = false
          status_codes = ["200"]
        }
      }
    }
    gitea_ssh = {
      protocol         = "tcp"
      listen_port      = 22
      destination_port = 30122
      health_check = {
        protocol = "tcp"
        port     = 30122
        interval = 10
        timeout  = 5
        retries  = 3
      }
    }
  }
}

module "firewall" {
  source     = "./modules/firewall"
  name       = "${var.cluster_name}-firewall"
  server_ids = values(module.servers.server_ids)

  rules = [
    {
      direction  = "in"
      protocol   = "icmp"
      port       = null
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "22"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]
}

module "kubernetes" {
  source       = "./modules/kubernetes"
  cluster_name = var.cluster_name
  ssh_key_path = var.ssh_private_key_path
  servers = {
    for name, config in var.servers : name => {
      public_ip  = module.servers.server_ipv4[name]
      private_ip = config.private_ip
      role       = config.role
    }
  }
  lb_external_private_ip = var.lb_external_private_ip
  lb_external_public_ip  = module.external-loadbalancer.ipv4
  lb_internal_private_ip = var.lb_internal_private_ip
  lb_internal_public_ip  = module.internal-loadbalancer.ipv4
}
