# Deployment of Grav webserver
##############################

module "deploy-grav-webserver-cert-domains" {
  source = "./modules/deploy-cert-domains"

  depends_on = [ module.deploy-consul ]

  certificate_domains = {
    domain_1 = {domain = local.project_domain_name, admin_email = local.project_admin_email},
    domain_2 = {domain = join("", [ "www.", local.project_domain_name]), admin_email = local.project_admin_email}
  }
}


module "deploy-grav-webserver" {
  source = "./modules/deploy-container-dynamic-ip"

  depends_on = [ module.deploy-consul ]
  
  lxd_remote                 = local.lxd_remote_name
  container_image            = join("-", [ local.project_id, "grav-webserver", var.image_version ])
  container_name             = join("-", [ local.project_id, "grav-webserver" ])
  container_profiles         = ["default"]
  container_network          = local.project_id
  container_cloud-init       = file("cloud-init/cloud-init-grav-bootstrap.yml")
  
  container_mounts = [
    {name = "grav-user", host_path = join("", [ "/var/containers/", local.project_id, "/website/grav" ]), mount_path = "/var/www/grav-admin/user", mount_readonly = false}
  ]
}


module "deploy-grav-webserver-haproxy-backend-service" {
  source = "./modules/deploy-haproxy-backend-services"

  depends_on = [ module.deploy-consul ]

  non_ssl_backend_services = [ join("-", [ local.project_id, "grav-webserver" ]) ]
}


module "deploy-grav-webserver-haproxy-acl-configuration" {
  source = "./modules/deploy-haproxy-configuration"

  depends_on = [ module.deploy-grav-webserver-haproxy-backend-service ]

  haproxy_host_only_acls = {
    domain     = {host = local.project_domain_name},
    domain-www = {host = join("", [ "www.", local.project_domain_name])}
  }
}


module "deploy-grav-webserver-haproxy-backend-configuration" {
  source = "./modules/deploy-haproxy-configuration"

  depends_on = [ module.deploy-grav-webserver-haproxy-backend-service ]

  haproxy_acl_use-backends = {
    domain     = {backend_service = join("-", [ local.project_id, "grav-webserver" ])},
    domain-www = {backend_service = join("-", [ local.project_id, "grav-webserver" ])}
  }
}
