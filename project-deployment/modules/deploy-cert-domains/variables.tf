# Input variable definitions

variable "certificate_domains" {
  description = "List of domains to request letsencrypt certificates. Each list member must be a map of domain and admin email for the certificate request."
  type = list(object({
    domain      = string
    admin_email = string
  }))
}