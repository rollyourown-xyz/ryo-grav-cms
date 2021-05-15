terraform {
  required_version = ">= 0.14"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

resource "consul_keys" "cert-domain" {

  for_each = var.certificate_domains

  # Domain name for the certificate is set as key, admin email as value
  key {
    path   = join("", [ "service/certbot/", each.value["domain"] ])
    value  = each.value["admin_email"]
    delete = true
  }
}
