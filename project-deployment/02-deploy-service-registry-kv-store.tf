# Deployment of Consul Service Registry and Key-Value Store module
##################################################################

module "deploy-consul" {
  source = "./modules/deploy-container-static-ip"
  
  depends_on = [ ]
  
  lxd_remote                 = local.lxd_remote_name
  host_external_ipv4_address = local.lxd_host_public_ipv4_address
  container_image            = join("-", [ local.project_name, "consul", var.image_version ])
  container_name             = join("-", [ local.project_name, "consul" ])
  container_profiles         = ["default"]
  container_network          = "lxdbr0"
  container_ipv4_address     = join(".", [ local.lxd_br0_network_part, "10" ])
  container_cloud-init       = file("cloud-init/cloud-init-basic.yml")

  container_mounts = [
    {name = "consul-data", host_path = join("", ["/var/containers/", local.project_name, "/consul/data"]), mount_path = "/var/consul", mount_readonly = false}
  ]
}
