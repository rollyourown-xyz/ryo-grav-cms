# Read variables for deployment as local variables
##################################################

# Configuration file paths
locals {
  project_configuration_path      = "${abspath(path.root)}/../configuration/configuration.yml"
}

# Basic project variables
locals {
  project_id          = yamldecode(file(local.project_configuration_path))["project_id"]
  project_domain_name = yamldecode(file(local.project_configuration_path))["project_domain_name"]
  project_admin_email = yamldecode(file(local.project_configuration_path))["project_admin_email"]
}

# LXD variables
locals {
  lxd_remote_name               = yamldecode(file(local.project_configuration_path))["project_id"]
  lxd_host_public_ipv4_address  = yamldecode(file(local.project_configuration_path))["host_public_ip"]
  lxd_br0_network_part          = yamldecode(file(local.project_configuration_path))["lxd_br0_network_part"]
  lxd_project_network_part      = yamldecode(file(local.project_configuration_path))["lxd_project_network_part"]
}


# Input Variables
#################

variable "image_version" {
  description = "Version of the images to deploy - Leave blank for 'terraform destroy'"
  type        = string
}
