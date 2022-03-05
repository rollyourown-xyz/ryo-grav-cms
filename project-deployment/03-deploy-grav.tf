# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

# Deploy Grav webserver
#######################

resource "lxd_container" "grav-webserver" {

  depends_on = [ module.deploy-grav-webserver-cert-domains ]

  remote     = var.host_id
  name       = join("-", [ local.project_id, "grav-webserver" ])
  image      = join("-", [ local.project_id, "grav-webserver", var.image_version ])
  profiles   = ["default"]
  
  config = { 
    "security.privileged": "false"
    "user.user-data" = file("cloud-init/cloud-init-grav-bootstrap.yml")
  }
  
  # Provide eth0 interface with dynamic IP address
  device {
    name = "eth0"
    type = "nic"

    properties = {
      name           = "eth0"
      network        = var.host_id
    }
  }
  
  # Mount container directory for persistent storage for grav user data
  device {
    name = "grav-user"
    type = "disk"
    
    properties = {
      source   = join("", [ "/var/containers/", local.project_id, "/grav/user/" ])
      path     = "/var/www/grav-admin/user"
      readonly = "false"
      shift    = "true"
    }
  }
}
