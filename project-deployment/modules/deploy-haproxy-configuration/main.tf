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

  # The folder for KVs is the ACL name, the host for the ACL is set as value for the key 'host'
  key {
    path   = join("", [ "service/haproxy/acl/", each.key, "/host" ])
    value  = each.value["host"]
    delete = true
  }
}

resource "consul_keys" "host_path_acls" {

  for_each = var.haproxy_host_path_acls

  # The folder for KVs is the ACL name, the host for the ACL is set as value for the key 'host'
  key {
    path   = join("", [ "service/haproxy/acl/", each.key, "/host" ])
    value  = each.value["host"]
    delete = true
  }
  
  # The folder for KVs is the ACL name, the path for the ACL is set as value for the key 'path'
  key {
    path   = join("", [ "service/haproxy/acl/", each.key, "/path" ])
    value  = each.value["path"]
    delete = true
  }
}

resource "consul_keys" "tcp_listeners" {

  for_each = var.haproxy_tcp_listeners

  # ACL for deny rule is set as key, no value is set
  key {
    path   = join("", [ "service/haproxy/tcp-listeners/", each.key ])
    value  = each.value["backend_service"]
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
