# Deployment of Certbot
#######################

module "deploy-certbot" {
  source = "./modules/deploy-container-dynamic-ip"
  
  depends_on = [ module.deploy-haproxy-dmz ]
  
  lxd_remote                 = local.lxd_remote_name
  container_image            = join("-", [ local.project_name, "certbot", var.image_version ])
  container_name             = "certbot"
  container_profiles         = ["default"]
  container_network          = "lxd-fe"
  container_cloud-init       = file("cloud-init/cloud-init-certbot.yml")
  
  container_mounts = [
    {name = "certbot-config", host_path = "/var/containers/ryo-grav-cms/certbot", mount_path = "/etc/letsencrypt", mount_readonly = false},
    {name = "certbot-tls", host_path = "/var/containers/ryo-grav-cms/tls", mount_path = "/var/tls", mount_readonly = false}
  ]
}