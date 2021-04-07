# Deployment of Certbot
#######################

module "deploy-certbot" {
  source = "./modules/deploy-container-dynamic-ip"
  
  depends_on = [ module.deploy-haproxy-dmz ]
  
  lxd_remote                 = local.lxd_remote_name
  container_image            = join("-", [ "certbot", var.image_version ])
  container_name             = "certbot"
  container_profiles         = ["default"]
  container_network          = "lxd-fe"
  container_cloud-init       = file("cloud-init/cloud-init-certbot.yml")
  
  container_mounts = [
    {name = "certbot-tls", host_path = "/var/container-directories/tls", mount_path = "/var/tls", mount_readonly = false}
  ]
}