# Deployment of project certificate parameters, HAProxy and Certbot for the loadbalancer / TLS proxy
####################################################################################################

module "deploy-loadbalancer-tls-proxy" {
  source = "./modules/deploy-container-static-ip"
  
  depends_on = [ module.deploy-consul ]
  
  lxd_remote                 = local.lxd_remote_name
  host_external_ipv4_address = local.lxd_host_public_ipv4_address
  container_image            = join("-", [ local.project_name, "loadbalancer-tls-proxy", var.image_version ])
  container_name             = join("-", [ local.project_name, "loadbalancer-tls-proxy" ])
  container_profiles         = ["default"]
  container_network          = "lxdbr0"
  container_ipv4_address     = join(".", [ local.lxd_br0_network_part, "11" ])
  
  container_cloud-init       = file("cloud-init/cloud-init-loadbalancer-tls-proxy.yml")
  
  container_proxies = [
    {name = "proxy0", protocol = "tcp", listen = "80", connect = "80"},
    {name = "proxy1", protocol = "tcp", listen = "443", connect = "443"}
  ]

  container_mounts = [
    {name = "certbot-data", host_path = join("", ["/var/containers/", local.project_name, "/certbot"]), mount_path = "/etc/letsencrypt", mount_readonly = false},
    {name = "haproxy-ssl", host_path = join("", ["/var/containers/", local.project_name, "/tls/concatenated"]), mount_path = "/etc/haproxy/ssl", mount_readonly = false},
    {name = "non-concat-certs", host_path = join("", ["/var/containers/", local.project_name, "/tls/non-concatenated"]), mount_path = "/var/certs", mount_readonly = false}
  ]
}
