#!/bin/sh

echo "Getting modules from repositories"
echo ""

## Common to all projects - generic host setup repository
echo "Executing 'git submodule add' for ryo-host repository"
git submodule add https://github.com/rollyourown-xyz/ryo-host modules/ryo-host

## Service Registry / Key-Value Store module
echo "Executing 'git submodule add' for ryo-service-registry-kv-store repository"
git submodule add https://github.com/rollyourown-xyz/ryo-service-registry-kv-store modules/ryo-service-registry-kv-store

## Loadbalancer / TLS Proxy module
echo "Executing 'git submodule add' for ryo-loadbalancer-tls-proxy"
git submodule add https://github.com/rollyourown-xyz/ryo-loadbalancer-tls-proxy modules/ryo-loadbalancer-tls-proxy
