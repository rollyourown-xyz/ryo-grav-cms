# Deployment of Grav webserver
##############################

module "deploy-webserver" {
  source = "./modules/deploy-container-dynamic-ip"
  
  lxd_remote                 = local.lxd_remote_name
  container_image            = join("-", [ "webserver", var.image_version ])
  container_name             = "webserver"
  container_profiles         = ["default"]
  container_network          = "lxd-fe"
  container_cloud-init       = file("cloud-init/cloud-init-grav-bootstrap.yml")
  
  container_mounts = [
    {name = "grav-user", host_path = "/var/containers/ryo-grav-cms/website/grav", mount_path = "/var/www/grav-admin/user", mount_readonly = false}
  ]
}