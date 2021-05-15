terraform {
  required_version = ">= 0.14"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "~> 2.12.0"
    }
  }
}

resource "consul_keys" "host_only_acls" {

  for_each = var.haproxy_host_only_acls

  # Host for the ACL is set as key, no value is set
  key {
    path   = join("", [ "service/haproxy/acl/", each.key, "/host" ])
    value  = each.value["host"]
    delete = true
  }
}

resource "consul_keys" "host_path_acls" {

  for_each = var.haproxy_host_path_acls

  # Host for the ACL is set as key, no value is set
  key {
    path   = join("", [ "service/haproxy/acl/", each.key, "/", each.value["host"] ])
    value  = ""
    delete = true
  }
  
  # Path for the ACL is set as key, no value is set
  key {
    path   = join("", [ "service/haproxy/acl/", each.key, "/", each.value["path"] ])
    value  = ""
    delete = true
  }
}

resource "consul_keys" "acl_denys" {

  for_each = toset(var.haproxy_acl_denys)

  # ACL for deny rule is set as key, no value is set
  key {
    path   = join("", [ "service/haproxy/deny/", each.key ])
    value  = ""
    delete = true
  }
}

resource "consul_keys" "acl_use-backends" {

  for_each = var.haproxy_acl_use-backends

  # ACL is set as key, backend service is set as value
  key {
    path   = join("", [ "service/haproxy/use-backend/", each.key ])
    value  = each.value["backend_service"]
    delete = true
  }
}
