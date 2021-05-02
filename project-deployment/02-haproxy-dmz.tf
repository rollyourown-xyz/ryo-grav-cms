# Deployment of DMZ HAProxy
###########################

module "deploy-haproxy-dmz" {
  source = "./modules/deploy-container-static-ip"

  lxd_remote                 = local.lxd_remote_name
  host_external_ipv4_address = local.lxd_host_public_ipv4_address
  container_image            = join("-", [ local.project_name, "haproxy-dmz", var.image_version ])
  container_name             = "haproxy-dmz"
  container_profiles         = ["default"]
  container_network          = "lxd-dmz"
  container_ipv4_address     = join(".", [ local.lxd_dmz_network_part, "10" ])
  container_cloud-init       = file("cloud-init/cloud-init-basic.yml")

  container_proxies = [
    {name = "proxy0", protocol = "tcp", listen = "80", connect = "80"},
    {name = "proxy1", protocol = "tcp", listen = "443", connect = "443"},
  ]

  container_mounts = [
    {name = "haproxy-ssl", host_path = "/var/containers/ryo-grav-cms/tls/haproxy", mount_path = "/etc/haproxy/ssl", mount_readonly = true}
  ]
}
