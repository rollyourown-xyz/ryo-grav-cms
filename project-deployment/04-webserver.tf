# Deployment of Grav webserver
##############################

# module "webserver-certificate-domains" {
#   source = "./modules/deploy-cert-domains"

#   depends_on = [ module.deploy-consul ]

#   certificate_domains = {
#     domain_1 = {domain = local.project_domain_name, admin_email = local.project_admin_email},
#     domain_2 = {domain = join("", [ "www.", local.project_domain_name]), admin_email = local.project_admin_email}
#   }
# }


## Deploy project service backends - !!! update image build to include consul service registration 
# module "deploy-webserver" {
#   source = "./modules/deploy-container-dynamic-ip"

#   lxd_remote                 = local.lxd_remote_name
#   container_image            = join("-", [ local.project_id, "webserver", var.image_version ])
#   container_name             = "webserver"
#   container_profiles         = ["default"]
#   container_network          = "lxd-fe"
#   container_cloud-init       = file("cloud-init/cloud-init-grav-bootstrap.yml")
  
#   container_mounts = [
#     {name = "grav-user", host_path = "/var/containers/ryo-grav-cms/website/grav", mount_path = "/var/www/grav-admin/user", mount_readonly = false}
#   ]
# }


## Configure HAProxy KVs for ACLs, Deny rules (?) and use-backend rules - depends on service backend deployment

