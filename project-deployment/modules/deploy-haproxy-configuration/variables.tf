# Input variable definitions

variable "haproxy_host_only_acls" {
  description = "Map of host-only ACLs for haproxy configuration. Each list member must be a map of objects. The object key is the ACL name and the object 'host' value is the ACL host."
  type = map(object({
    host = string
  }))
  default = {}
}

variable "haproxy_host_path_acls" {
  description = "Map of host/path ACLs for haproxy configuration. Each list member must be a map of objects. The object key is the ACL name, the object 'host' value is the ACL host and the object 'path' value is the ACL path."
  type = map(object({
    host = string
    path = string
  }))
  default = {}
}

variable "haproxy_acl_denys" {
  description = "List of ACLs to use for http-request deny in haproxy configuration. Each list member is a string with the ACL name to use."
  type = list(string)
  default = []
}

variable "haproxy_acl_use-backends" {
  description = "Map of ACLs to use for use-backend haproxy configuration. Each list member must be a map of objects. The object key is the ACL name, the object 'backend' value is the backend service to use."
  type = map(object({
    backend_service = string
  }))
  default = {}
}
