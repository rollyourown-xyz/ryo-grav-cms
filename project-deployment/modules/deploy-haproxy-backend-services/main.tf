terraform {
  required_version = ">= 0.14"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

resource "consul_keys" "ssl_backend_services" {

  for_each = toset(var.ssl_backend_services)

  # The backend service name is the key. The value is empty.
  key {
    path   = join("", [ "service/haproxy/backends/ssl/", each.key ])
    value  = ""
    delete = true
  }
}

resource "consul_keys" "non_ssl_backend_services" {

  for_each = toset(var.non_ssl_backend_services)

  # The backend service name is the key. The value is empty.
  key {
    path   = join("", [ "service/haproxy/backends/no-ssl/", each.key ])
    value  = ""
    delete = true
  }
}
