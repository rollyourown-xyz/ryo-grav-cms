# Deploy key-value pairs to consul KV store for providing haproxy with configuration for backends

This module deploys key-value pairs to consul KV store for use by the haproxy service. Backends are specified by input variables:

## ssl_backend_services (list of strings)

List of backend services for haproxy configuration where SSL connection is used to the backend server. Each list member is a string providing the name of a backend service to add. The resulting backend service configuration in haproxy will be:

        backend <backend_service>
           redirect scheme https code 301 if !{ ssl_fc }
           http-request set-header X-SSL %[ssl_fc]
           balance roundrobin
           server-template <backend_service> 1 _<backend_service>._tcp.service.consul resolvers consul resolve-prefer ipv4 init-addr none ssl verify none check

## non_ssl_backend_services (list of strings)

List of backend services for haproxy configuration where no SSL connection is used to the backend server. Each list member is a string providing the name of a backend service to add. The resulting backend service configuration in haproxy will be:

        backend <backend_service>
           redirect scheme https code 301 if !{ ssl_fc }
           http-request set-header X-SSL %[ssl_fc]
           balance roundrobin
           server-template <backend_service> 1 _<backend_service>._tcp.service.consul resolvers consul resolve-prefer ipv4 init-addr none check
