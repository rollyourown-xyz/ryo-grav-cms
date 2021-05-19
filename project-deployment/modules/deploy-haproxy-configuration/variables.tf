# Input variable definitions

variable "haproxy_host_only_acls" {
  description = "Map of host-only ACLs for haproxy configuration."
  type = map(object({
    host = string
  }))
  default = {}
}

variable "haproxy_host_path_acls" {
  description = "Map of host/path ACLs for haproxy configuration."
  type = map(object({
    host = string
    path = string
  }))
  default = {}
}

variable "haproxy_tcp_listeners" {
  description = "Map of TCP Listeners to use in haproxy configuration."
  type = map(object({
    backend_service = string
  }))
  default = {}
}

variable "haproxy_acl_denys" {
  description = "List of ACLs to use for http-request deny in haproxy configuration."
  type = list(string)
  default = []
}

variable "haproxy_acl_use-backends" {
  description = "Map of ACLs to use for use-backend haproxy configuration."
  type = map(object({
    backend_service = string
  }))
  default = {}
}
