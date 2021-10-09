# Deploy Grav webserver
#######################

resource "lxd_container" "grav-webserver" {
  remote     = var.host_id
  name       = "grav-webserver"
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
      source   = join("", [ "/var/containers/", local.project_id, "/website/grav" ])
      path     = "/var/www/grav-admin/user"
      readonly = "false"
      shift    = "true"
    }
  }
}

# Deploy certbot configuration for project domain
#################################################

module "deploy-grav-webserver-cert-domains" {
  source = "../../ryo-service-proxy/module-deployment/modules/deploy-cert-domains"

  certificate_domains = {
    domain_1 = {domain = local.project_domain_name, admin_email = local.project_admin_email},
    domain_2 = {domain = join("", [ "www.", local.project_domain_name]), admin_email = local.project_admin_email}
  }
}


# Deploy HAProxy configuration
##############################

module "deploy-grav-webserver-haproxy-backend-service" {
  source = "../../ryo-service-proxy/module-deployment/modules/deploy-haproxy-backend-services"
  non_ssl_backend_services = [ "grav-webserver" ]
}

module "deploy-grav-webserver-haproxy-acl-configuration" {
  source = "../../ryo-service-proxy/module-deployment/modules/deploy-haproxy-configuration"

  depends_on = [ module.deploy-grav-webserver-haproxy-backend-service ]

  haproxy_host_only_acls = {
    domain     = {host = local.project_domain_name},
    domain-www = {host = join("", [ "www.", local.project_domain_name])}
  }
}

module "deploy-grav-webserver-haproxy-backend-configuration" {
  source = "../../ryo-service-proxy/module-deployment/modules/deploy-haproxy-configuration"

  depends_on = [ module.deploy-grav-webserver-haproxy-backend-service ]

  haproxy_acl_use-backends = {
    domain     = {backend_service = "grav-webserver"},
    domain-www = {backend_service = "grav-webserver"}
  }
}
