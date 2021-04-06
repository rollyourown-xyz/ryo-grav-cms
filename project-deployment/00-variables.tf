# Read variables for deployment as local variables
##################################################

# Configuration file paths
locals {
  host_config_path    = yamldecode(file("${abspath(path.root)}/../configuration/config_path.yml"))["host_config_path"]
  project_config_path = yamldecode(file("${abspath(path.root)}/../configuration/config_path.yml"))["project_config_path"]
}

# LXD variables
locals {
  lxd_remote_name               = yamldecode(file(local.host_config_path))["host_hostname"]
  lxd_host_private_ipv4_address = yamldecode(file(local.host_config_path))["host_wireguard_address"]
  lxd_host_public_ipv4_address  = yamldecode(file(local.host_config_path))["host_public_ip"]
  lxd_core_trust_password       = yamldecode(file(local.host_config_path))["lxd_core_trust_password"]
}


# Input Variables
#################

variable "image_version" {
  description = "Version of the images to deploy"
  type        = string
}
