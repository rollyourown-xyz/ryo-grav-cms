# Deploy key-value pairs to consul KV store for providing certbot with configuration for letsencrypt certificate management

This module deploys key-value pairs to consul KV store for use by the certbot service. Certificates to be managed are specified by input variable:

* certificate_domains (map of objects): List of certificate domains to be managed by certbot. Each list member must be a map of properties to configure. Each map item must specify the domain to be managed and an administrator email to use for letsencrypt requests. The form for a map is:

        {domain = string, admin_email = string}
