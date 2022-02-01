# Deploy Ingress Proxy configuration
####################################

module "deploy-grav-webserver-ingress-proxy-backend-service" {
  source = "../../ryo-ingress-proxy/module-deployment/modules/deploy-ingress-proxy-backend-services"

  depends_on = [ lxd_container.grav-webserver ]

  non_ssl_backend_services = [ join("-", [ local.project_id, "grav-webserver" ]) ]
}

module "deploy-grav-webserver-ingress-proxy-configuration" {
  source = "../../ryo-ingress-proxy/module-deployment/modules/deploy-ingress-proxy-configuration"

  depends_on = [ module.deploy-grav-webserver-ingress-proxy-backend-service ]

  ingress-proxy_host_only_acls = {
    join("-", [ local.project_id, "domain" ]) = {host = local.project_domain_name}
  }

  ingress-proxy_acl_use-backends = {
    join("-", [ local.project_id, "domain" ]) = {backend_service = join("-", [ local.project_id, "grav-webserver" ])}
  }
}
