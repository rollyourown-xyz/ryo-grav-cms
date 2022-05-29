# SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
# SPDX-License-Identifier: GPL-3.0-or-later

#--------------------------------------------------------------------
# Packer template for building LXD container image for Grav webserver
# Ubuntu minimal images are used as base images
#--------------------------------------------------------------------

## Input variables
##

# Specify the host_id for which to build the image
variable "host_id" {
  description = "Mandatory: The host_id for which to build the image."
  type        = string
}

# Specify the version number of the image to be built
variable "version" {
  description = "Mandatory: The version identifier to be added to the output image name."
  type        = string
}

# Specify the grav version to use in the image build
variable "grav_version" {
  description = "Mandatory: The grav version to use in the image build."
  type        = string
}

variable "remote_build" {
  description = "Optional: Whether to build on the remote LXD host."
  type        = bool
  default     = false
}

## Local configuration variables
##

# Name for the container for which the image is to be built
locals {
  service_name = "grav-webserver"
}

# Variables from configuration files
locals {
  project_id      = yamldecode(file("${abspath(path.root)}/../configuration/configuration_${var.host_id}.yml"))["project_id"]
  remote_lxd_host = var.host_id
}

## Parameters for the build process
##

locals {
  build_image_os      = "ubuntu-minimal"
  build_image_release = "focal"
  
  build_container_name = ( var.remote_build ? "${ join(":", [ var.host_id, "packer-lxd-build" ]) }" : "packer-lxd-build" )

  build_inventory_file = "${abspath(path.root)}/playbooks/inventory.yml"
  build_playbook_file  = "${abspath(path.root)}/playbooks/provision-grav-webserver.yml"
  build_extra_vars     = "host_id=${var.host_id} grav_version=${var.grav_version}"
}

## Computed local variables
##

# Computed parameters for the output image
locals {
  output_image_name        = "${ join("-", [ local.project_id, local.service_name, var.version ]) }"
  output_image_description = "${ join(" ", [
      join(":", [ local.build_image_os , local.build_image_release ]),
      "image for",
      local.service_name,
      "- v",
      var.version
    ]
  )}"
}

# Computed extra_arguments for ansible provisioner
locals {
  ansible_remote_argument = "${ join("", [ "ansible_lxd_remote=", var.host_id ]) }"
}


## Build template
##

source "lxd" "container" {
  image               = join(":", [ local.build_image_os , local.build_image_release ])
  profile             = "build"
  container_name      = local.build_container_name
  output_image        = local.output_image_name
  publish_remote_name = ( var.remote_build ? var.host_id : "" )

  publish_properties = {
    description = local.output_image_description
    os          = local.build_image_os
    release     = local.build_image_release
  }
}

build {
  sources = ["source.lxd.container"]

  provisioner "ansible" {
    inventory_file  = local.build_inventory_file
    playbook_file   = local.build_playbook_file
    extra_arguments = ( var.remote_build ? [ "-e", local.ansible_remote_argument, "--extra-vars", local.build_extra_vars ] : [ "--extra-vars", local.build_extra_vars ] )
  }
}
