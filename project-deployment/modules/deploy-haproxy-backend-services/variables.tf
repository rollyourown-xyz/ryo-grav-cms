# Input variable definitions

variable "ssl_backend_services" {
  description = "List of SSL backend services to configure."
  type = list(string)
  default = []
}

variable "non_ssl_backend_services" {
  description = "List of non-SSL backend services to configure."
  type = list(string)
  default = []
}
