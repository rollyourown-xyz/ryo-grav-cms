# Global provider definitions for deployment
############################################

terraform {
  required_version = ">= 0.14"
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "~> 1.5.0"
    }
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

provider "lxd" {

  config_dir                   = "$HOME/snap/lxd/current/.config/lxc"
  generate_client_certificates = false
  accept_remote_certificate    = false

  lxd_remote {
    name     = local.lxd_remote_name
    default  = true
  }
}

provider "consul" {
  address    = join("", [ local.lxd_br0_network_part, ".10", ":8500" ])
  scheme     = "http"
  datacenter = local.project_id
}
